SynthDef(\looper, { |outBus=0, inBus=0, inBus2=1, in1Mul=1, in2Mul=1, tapBus=2, loopTime=19, record=0, buffer|
    var input, input2, loop, tapPhase, tap;
    input = SoundIn.ar(inBus, in1Mul);
    input2 = SoundIn.ar(inBus2, in2Mul);
    loop = InFeedback.ar(2, 1);
    tapPhase = DelTapWr.ar(buffer, ((input + input2) * record) + loop);
    tap = DelTapRd.ar(buffer, tapPhase, loopTime, 1);
    // tap output
    OffsetOut.ar(tapBus, DelayC.ar(tap, 1, 440.reciprocal - ControlRate.ir.reciprocal));
    // main output
    OffsetOut.ar(outBus, (input + input2 + tap!2));
}).add;

x = Synth(\looper, [\buffer, ~looper1, \outBus, ~out, \inBus, 0, \inBus, 1]);
x.set(\record, 1);
x.set(\record, 0);
x.set(\in2Mul, 0);
x.set(\in1Mul, 1);
// x.set(\loopTime, 5);
// x.set(\loopTime, 3);
// x.set(\loopTime, 1);
// x.free;
// b.free;

(
    var synth, win, col1, col2, row1, row2;
    col1 = 20; col2=50; row1 = 20; row2 = 30;
    // synth
    synth = Synth(\looper, [\buffer, ~looper1, \outBus, ~out]);
    // GUI window
    win = Window(\looper, Rect(0, 0, 500, 500), false);
    // input1 slider
    StaticText(win, Rect(col1, row1, 10, 10)).font_(Font("Helvetica", 10)).string_("1");
    Slider(win, Rect(col1, row2, 20, 200))
        .action_({|in1| synth.set(\in1Mul, [0, 1.0, \exp].asSpec.map(in1.value)) });
    // input2 slider
    StaticText(win, Rect(col2, row1, 10, 10)).font_(Font("Helvetica", 10)).string_("2");
    Slider(win, Rect(col2, row2, 20, 200)) 
        .action_({|in2| synth.set(\in2Mul, [0, 1.0, \exp].asSpec.map(in2.value)) });
    win.onClose_({synth.free}).front;
)
