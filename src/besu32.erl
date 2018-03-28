%% Copyright (c) 2018, Thomas Bhatia <thomas.bhatia@eo.io>.
%% All rights reserved.
%%
%% Redistribution and use in source and binary forms, with or without
%% modification, are permitted provided that the following conditions are
%% met:
%%
%% * Redistributions of source code must retain the above copyright
%%   notice, this list of conditions and the following disclaimer.
%%
%% * Redistributions in binary form must reproduce the above copyright
%%   notice, this list of conditions and the following disclaimer in the
%%   documentation and/or other materials provided with the distribution.
%%
%% * The names of its contributors may not be used to endorse or promote
%%   products derived from this software without specific prior written
%%   permission.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-module(besu32).

%% API exports
-export([encode/1, decode/1]).


%%====================================================================
%% API functions
%%====================================================================
encode(Bin) when is_binary(Bin) ->
    encode_binary(Bin, <<>>).

decode(Bin) when is_binary(Bin) ->
    decode_binary(Bin, <<>>).

%%====================================================================
%% Encode functions
%%====================================================================

encode_binary(<<>>, Acc) ->
    Acc;
encode_binary(<<I:1>>, Acc) ->
    encode_binary(<<(I bsl 4):5>>, Acc, 4);
encode_binary(<<I:2>>, Acc) ->
    encode_binary(<<(I bsl 3):5>>, Acc, 1);
encode_binary(<<I:3>>, Acc) ->
    encode_binary(<<(I bsl 2):5>>, Acc, 6);
encode_binary(<<I:4>>, Acc) ->
    encode_binary(<<(I bsl 1):5>>, Acc, 3);
encode_binary(<<Body:5/bits, Rest/bits>>, Acc) ->
    encode_binary(Rest, <<Acc/bits, (b32e(Body))>>).

encode_binary(<<Body:5/bits>>, Acc, Padby) ->
    Pad = binary:copy(<<"=">>, Padby),
    <<Acc/bits, (b32e(Body)), Pad/binary>>.

%%====================================================================
%% Decode functions
%%====================================================================

decode_binary(<<>>, Acc) ->
    Acc;
decode_binary(<<Body, "======">>, Acc) ->
    <<Acc/bits, (b32d(Body) bsr 2):3>>;
decode_binary(<<Body, "====">>, Acc) ->
    <<Acc/bits, (b32d(Body) bsr 4):1>>;
decode_binary(<<Body, "===">>, Acc) ->
    <<Acc/bits, (b32d(Body) bsr 1):4>>;
decode_binary(<<Body, "=">>, Acc) ->
    <<Acc/bits, (b32d(Body) bsr 3):2>>;
decode_binary(<<Body, Rest/binary>>, Acc) ->
    decode_binary(Rest, <<Acc/bits, (b32d(Body)):5>>).

%%====================================================================
%% Internal functions
%%====================================================================

b32d(I) when I >= $2 andalso I =< $7 ->
    I - 24;
b32d(I) when I >= $a andalso I =< $z ->
    I - $a;
b32d(I) when I >= $A andalso I =< $Z ->
    I - $A.

-compile({inline, [{b32e, 1}]}).
b32e(<<X:5>>) ->
    element(X+1,
        {$A, $B, $C, $D, $E, $F, $G, $H, $I, $J, $K, $L, $M,
         $N, $O, $P, $Q, $R, $S, $T, $U, $V, $W, $X, $Y, $Z,
         $2, $3, $4, $5, $6, $7}).
