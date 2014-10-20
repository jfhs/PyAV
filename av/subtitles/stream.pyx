cimport libav as lib

from av.frame cimport Frame
from libc.stdint cimport uint8_t, int64_t
from av.subtitles.subtitle cimport SubtitleProxy, SubtitleSet
from av.packet cimport Packet
from av.utils cimport err_check


cdef class SubtitleStream(Stream):
    
    cdef _decode_one(self, lib.AVPacket *packet, int *data_consumed):
        
        cdef SubtitleProxy proxy = SubtitleProxy()
        
        cdef int completed_frame = 0
        data_consumed[0] = err_check(lib.avcodec_decode_subtitle2(self._codec_context, &proxy.struct, &completed_frame, packet))
        if not completed_frame:
            return
        
        return SubtitleSet(proxy)

    cpdef encode(self, SubtitleSet sub):

        cdef int max_sz = 1024*1024
        cdef uint8_t* buffer = <uint8_t*>lib.av_malloc(max_sz)
        buffer[0] = 1
        cdef int sz = err_check(lib.avcodec_encode_subtitle(
            self._codec_context,
            buffer,
            max_sz,
            &sub.proxy.struct,
        ))
        cdef Packet packet = Packet()
        packet.struct.data = buffer
        packet.struct.size = sz
        packet.struct.pts = sub.proxy.pts
        packet.struct.duration = sub.proxy.end_display_time
        packet.struct.dts = packet.struct.dts
        return packet