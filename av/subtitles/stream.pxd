from av.stream cimport Stream


cdef class SubtitleStream(Stream):

    cpdef encode(self, Subtitle)
