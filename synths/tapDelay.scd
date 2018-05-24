SynthDef(\looper, { |outBus=0, inBus=0, inBus2=1, in1Mul=1, in2Mul=1, outMul=1, tapBus=2, loopTime=19.9, record=0, buffer|
    var input, input2, loop, tapPhase, tap;
    input = SoundIn.ar(inBus, in1Mul);
    input2 = SoundIn.ar(inBus2, in2Mul);
    loop = InFeedback.ar(2, 1);
    tapPhase = DelTapWr.ar(buffer, ((input + input2) * record) + loop);
    tap = DelTapRd.ar(buffer, tapPhase, loopTime, 1);
    // tap output
    OffsetOut.ar(tapBus, DelayC.ar(tap, 1, 440.reciprocal - ControlRate.ir.reciprocal));
    // main output
    OffsetOut.ar(outBus, tap*outMul!2);
}).add;
