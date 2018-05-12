SynthDef(\looper, { |outBus=0, inBus=4, tapBus=2, inMul=1, loopMul=1, loopTime=1, buffer|
    var input, loop, tapPhase, tap;
    input = In.ar(inBus, 1) * inMul;
    loop = InFeedback.ar(2, 1);
    tapPhase = DelTapWr.ar(buffer, input + loop);
    tap = DelTapRd.ar(buffer, tapPhase, loopTime, 1, loopMul);
    // tap output
    OffsetOut.ar(tapBus, DelayC.ar(tap, 1, 440.reciprocal - ControlRate.ir.reciprocal));
    // main output
    OffsetOut.ar(outBus, (input + tap)!2)
}).add;

x = Synth(\looper, [\buffer, ~looper1, \outBus, ~out, \inBus, ~in1]);
x.set(\inMul, 0);
x.set(\inMul, 1);
x.set(\loopTime, 5);
x.set(\loopTime, 3);
x.set(\loopTime, 1);
x.free;
b.free;
