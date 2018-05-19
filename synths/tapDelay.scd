SynthDef(\looper, { |outBus=0, inBus, inBus2, in1Mul=1, in2Mul=1, outMul=1, tapBus=2, loopTime=19.9, record=0, buffer|
    var input, input2, loop, tapPhase, tap;
    input = In.ar(inBus, 1) * in1Mul;
    input2 = In.ar(inBus2, 1) * in2Mul;
    loop = InFeedback.ar(tapBus, 1);
    tapPhase = DelTapWr.ar(buffer, ((input + input2) * record) + loop);
    tap = DelTapRd.ar(buffer, tapPhase, loopTime, 1);
    // tap output
    OffsetOut.ar(tapBus, DelayC.ar(tap, 1, 440.reciprocal - ControlRate.ir.reciprocal));
    // main output
    OffsetOut.ar(outBus, (input + input2 + tap!2) * outMul);
}).add;


