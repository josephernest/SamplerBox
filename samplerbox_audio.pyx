#
#  SamplerBox 
#
#  author:    Joseph Ernest (twitter: @JosephErnest, mail: contact@samplerbox.org)
#  url:       http://www.samplerbox.org/
#  license:   Creative Commons ShareAlike 3.0 (http://creativecommons.org/licenses/by-sa/3.0/)
#
#  samplerbox_audio.pyx: Audio engine (Cython) 
#



import cython
import numpy
cimport numpy

cdef extern from "arm_neon.h":
    ctypedef float float32_t
    ctypedef float float32x4_t

    float32x4_t vld1q_f32(float32_t* ptr)
    void vst1q_f32(float32_t *ptr, float32x4_t val)
    float32x4_t vmulq_n_f32(float32x4_t a, float32_t b)

def mixaudiobuffers(list playingsounds, list rmlist, int frame_count, numpy.ndarray FADEOUT, int FADEOUTLENGTH, numpy.ndarray SPEED, double GLOBALVOLUME):
    cdef int i, ii, k, l, N, length, looppos, fadeoutpos, mptr
    cdef float speed, newsz, pos, j, velocity
    cdef numpy.ndarray b = numpy.zeros(2 * frame_count, numpy.float32)      # output buffer
    cdef float* bb = <float *> (b.data)                                     # and its pointer
    cdef numpy.ndarray z
    cdef short* zz
    cdef float32_t sample[4]
    cdef float32x4_t sample_vector
    cdef float* fadeout = <float *> (FADEOUT.data)
    cdef double multiplier
    cdef char is_fadeout

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

            # vectorisation optimisations
            mptr = 2 * k
            sample[0] = <float32_t> zz[mptr]
            sample[1] = <float32_t> zz[mptr + 1]
            sample[2] = <float32_t> zz[mptr + 2]
            sample[3] = <float32_t> zz[mptr + 3]
            sample_vector = vld1q_f32(sample)
            sample_vector = vmulq_n_f32(sample_vector, multiplier)
            vst1q_f32(sample, sample_vector)

            bb[2 * i] += sample[0] + j * (sample[2] - sample[0])                                               # linear interpolation
            bb[2 * i + 1] += sample[1] + j * (sample[3] - sample[1])

        if is_fadeout == 1:
            if fadeoutpos > FADEOUTLENGTH: 
                rmlist.append(snd)   
            snd.fadeoutpos += N

        snd.pos += ii * speed

    return b

def binary24_to_int16(char *data, int length):
    cdef int i
    res = numpy.zeros(length, numpy.int16)
    b = <char *>((<numpy.ndarray>res).data)
    for i in range(length):
        b[2*i] = data[3*i+1]
        b[2*i+1] = data[3*i+2]
    return res
