#
#  SamplerBox 
#
#  author:    Joseph Ernest (twitter: @JosephErnest, mail: contact@samplerbox.org)
#             P.T. (NEON instruction set)
#  url:       http://www.samplerbox.org/
#  license:   Creative Commons ShareAlike 3.0 (http://creativecommons.org/licenses/by-sa/3.0/)
#
#  samplerbox_audio.pyx: Audio engine (Cython) 
#



import cython
import numpy
cimport numpy

cdef extern from "arm_neon.h":
    # "c type" here is effectively ignored by Cython
    ctypedef short int16_t
    ctypedef short int16x4_t
    ctypedef short int16x8_t
    ctypedef long int32x2_t
    ctypedef long int32x4_t
    ctypedef float float32_t
    ctypedef float float32x2_t
    ctypedef float float32x4_t

    float32x4_t vld1q_f32(float32_t* ptr)
    void vst1_f32(float32_t *ptr, float32x2_t val)
    void vst1q_f32(float32_t *ptr, float32x4_t val)
    int16x4_t vld1_s16(int16_t* ptr)
    int16x8_t vld1q_s16(int16_t* ptr)
    void vst1q_s16(int16_t *ptr, int16x8_t val)

    float32x4_t vdupq_n_f32(float32_t value)

    int16x4_t vaddq_s16(int16x8_t a, int16x8_t b)
    float32x2_t vadd_f32(float32x2_t a, float32x2_t b)
    float32x4_t vaddq_f32(float32x4_t a, float32x4_t b)
    float32x2_t vsub_f32(float32x2_t a, float32x2_t b)
    float32x2_t vmul_n_f32(float32x2_t a, float32_t b)
    float32x4_t vmulq_n_f32(float32x4_t a, float32_t b)
    float32x2_t vget_high_f32(float32x4_t a)
    float32x2_t vget_low_f32(float32x4_t a)
    int16x8_t vcombine_s16(int16x4_t a, int16x4_t b)
    int32x4_t vcombine_s32(int32x2_t a, int32x2_t b) 

    int16x4_t vmovn_s32(int32x4_t a)
    int32x4_t vmovl_s16(int16x4_t a)
    int32x2_t vcvt_s32_f32(float32x2_t a)
    float32x4_t vcvtq_f32_s32(int32x4_t a)

def mixaudiobuffers(list playingsounds, list rmlist, int frame_count, numpy.ndarray FADEOUT, int FADEOUTLENGTH, numpy.ndarray SPEED, double GLOBALVOLUME):
    cdef int i, ii, k, l, N, length, looppos, fadeoutpos
    cdef float speed, newsz, pos, j, velocity

    cdef int channel_size = 2 * frame_count
    cdef numpy.ndarray b = numpy.require(numpy.zeros(channel_size, numpy.int16), requirements=['A', 'C'])      # output buffer
    cdef short* bb = <short *> (b.data)                                     # and its pointer

    # input sample buffers and calculation register references
    cdef numpy.ndarray z
    cdef short* zz
    cdef int16x4_t zz_sample
    cdef int32x4_t zz_sample32
    cdef float32_t sample[2]
    cdef float32x4_t sample_vector
    cdef float32x2_t sample_pair_vector[2]
    cdef int32x2_t master
    cdef int16x4_t low_combined, high_combined
    cdef int16x8_t buffer_vector, full_combined

    # velocity / ADSR / fadeout variables
    cdef float* fadeout = <float *> (FADEOUT.data)
    cdef double multiplier
    cdef char is_fadeout

    sound_no = 0
    for snd in playingsounds:
        pos = snd.pos
        fadeoutpos = snd.fadeoutpos
        velocity = snd.velocity * GLOBALVOLUME
        looppos = snd.sound.loop
        length = snd.sound.nframes
        if snd.isfadeout:
            is_fadeout = 1
        else:
            is_fadeout = 0
        speed = SPEED[snd.note - snd.sound.midinote]
        newsz = frame_count * speed
        z = snd.sound.data
        zz = <short *> (z.data)

        N = frame_count

        if (pos + frame_count * speed > length - 4) and (looppos == -1):
            rmlist.append(snd)
            N = <int> ((length - 4 - pos) / speed)

        multiplier = velocity

        ii = 0            
        for i in range(N):
            j = pos + ii * speed
            ii += 1                  
            k = <int> j
            if k > length - 2:
                pos = looppos + 1
                snd.pos = pos
                ii = 0
                j = pos + ii * speed   
                k = <int> j
            if is_fadeout == 1:
               multiplier = velocity * fadeout[fadeoutpos + i]

            j -= k            

            # vectorise samples at the pointer location
            zz_sample = vld1_s16(&zz[2 * k])
            # convert to floating-point format
            zz_sample32 = vmovl_s16(zz_sample)
            sample_vector = vcvtq_f32_s32(zz_sample32)

            # pre-mix multiplier
            sample_vector = vmulq_n_f32(sample_vector, multiplier)

            # linear interpolation
            sample_pair_vector[0] = vget_low_f32(sample_vector)                            # sample0, sample1
            sample_pair_vector[1] = vget_high_f32(sample_vector)                           # sample2, sample3
            sample_pair_vector[1] = vsub_f32(sample_pair_vector[1], sample_pair_vector[0]) # s2-s0, s3-s1
            sample_pair_vector[1] = vmul_n_f32(sample_pair_vector[1], j)                   # j*(s2-s0), ...
            sample_pair_vector[1] = vadd_f32(sample_pair_vector[1], sample_pair_vector[0]) # s0 + j*(s2-s0), ...

            master = vcvt_s32_f32(sample_pair_vector[1])
            if i % 2 == 0:
                 previous_master = master
            else:
                 if i % 4 == 1:
                     low_combined = vmovn_s32(vcombine_s32(previous_master, master))
                 else: # i % 3 == 3
                     high_combined = vmovn_s32(vcombine_s32(previous_master, master))
                     full_combined = vcombine_s16(low_combined, high_combined)
                     buffer_vector = vld1q_s16(&bb[i * 2 - 6])                             # load buffer at the position
                     buffer_vector = vaddq_s16(buffer_vector, full_combined)               # add calculated samples to the buffer
                     vst1q_s16(&bb[i * 2 - 6], buffer_vector)

        if is_fadeout == 1:
            if fadeoutpos > FADEOUTLENGTH: 
                rmlist.append(snd)   
            snd.fadeoutpos += N

        snd.pos += ii * speed
        sound_no += 1

    return b

# Calculate how many mixing channels are needed
#
# Mixer mixes two channels at a time (2 x 32bit float frame x 2 channels = 128bit)
# so the result always have to be a multiply of two.
#
# Extra 8 channels are added to prevent race condition if more sounds are triggered since
# mixing buffer has been allocated.
#
def mixing_channels(int sounds):
    if sounds % 2 > 0:
      sounds += 1
    return sounds + 8

def binary24_to_int16(char *data, int length):
    cdef int i
    res = numpy.zeros(length, numpy.int16)
    b = <char *>((<numpy.ndarray>res).data)
    for i in range(length):
        b[2*i] = data[3*i+1]
        b[2*i+1] = data[3*i+2]
    return res
