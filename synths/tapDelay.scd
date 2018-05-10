// write a signal into a delay, tap it at multiple times
SynthDef(\test, { |out=0, in=4, buffer|
    var input, loop, tapPhase, tap1, tap2, tap3;
    input = In.ar(in, 1);
    loop = In.ar(out+2, 1); // record in on channel 3 (looped audio)
    tapPhase = DelTapWr.ar(buffer, input + loop);
    tap1 = DelTapRd.ar(buffer, tapPhase,
        3.9, // tap time
        1, // no interp
        1.0 // muls for each tap
    );
    Out.ar(out, [input + tap1, input + tap1, tap1]) // send delayed signal out on channel 2 for feeding back
}).add;

x = Synth(\test, [\buffer, ~buffer, \out, ~out, \in, ~in1]);
x.free;
b.free;