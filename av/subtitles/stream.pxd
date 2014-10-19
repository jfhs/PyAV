from av.stream cimport Stream
from av.subtitles.subtitle cimport SubtitleSet


cdef class SubtitleStream(Stream):

    cpdef encode(self, SubtitleSet sub)
