// write a signal into a delay, tap it at multiple times
SynthDef(\test, { |out=0, in=2, buffer|
    var src, tapPhase, tap1, tap2, tap3;
    // src = WhiteNoise.ar(0.2) * Decay.kr(Dust.kr(3), 0.2);
    src = In.ar(in, 1);
    tapPhase = DelTapWr.ar(buffer, src);
    tap1 = DelTapRd.ar(buffer, tapPhase,
        3.9, // tap time
        1, // no interp
        1.0 // muls for each tap
    );
    Out.ar(out, [src, tap1])
}).add;

x = Synth(\test, [\buffer, ~buffer]);
x.free;
b.free;