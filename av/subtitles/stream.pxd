from av.stream cimport Stream
from av.subtitles.subtitle import SubtitleSet


cdef class SubtitleStream(Stream):

    cpdef encode(self, SubtitleSet)
