SynthDef(\looper, { |outBus=0, inBus=4, inBus2=5, tapBus=2, inMul=1, inMul2=1,loopMul=1, loopTime=2, record=0, buffer|
    var input, input2, loop, tapPhase, tap;
    input = In.ar(inBus, 1) * inMul;
    input2 = In.ar(inBus2, 1) * inMul2;
    loop = InFeedback.ar(2, 1);
    tapPhase = DelTapWr.ar(buffer, ((input + input2) * record) + loop);
    tap = DelTapRd.ar(buffer, tapPhase, loopTime, 1, loopMul);
    // tap output
    OffsetOut.ar(tapBus, DelayC.ar(tap, 1, 440.reciprocal - ControlRate.ir.reciprocal));
    // main output
    OffsetOut.ar(outBus, (input + input2 + tap)!2)
}).add;

x = Synth(\looper, [\buffer, ~looper1, \outBus, ~out, \inBus, ~in1, \inBus, ~in2]);
x.set(\record, 1);
x.set(\record, 0);
// x.set(\inMul, 0);
// x.set(\inMul, 1);
// x.set(\loopTime, 5);
// x.set(\loopTime, 3);
// x.set(\loopTime, 1);
// x.free;
// b.free;

// inMul probably needs to fade in and out to prevent pops
// stereo handling
