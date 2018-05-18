SynthDef(\looper, { |outBus=0, inBus=0, inBus2=1, in1Mul=1, in2Mul=1, tapBus=2, loopTime=19.9, record=0, buffer|
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

// buffer
~looperBuf1 = Buffer.alloc(s, 44100 * 20, 1); // a 20 second 1 channel Buffer
// x = Synth(\looper, [\buffer, ~looperBuf1, \outBus, ~out, \inBus, 0, \inBus, 1]);

(
    var synth, win, recButton, firstTime, startTime,
    col1, col2, col3, row1, row2;
    firstTime=true;
    startTime=0;
    col1 = 20; col2=50; col3=80; row1 = 20; row2 = 30;
    // synth
    synth = Synth(\looper, [\buffer, ~looperBuf1, \outBus, ~out]);
    // GUI window
    win = Window(\looper, Rect(0, 0, 500, 500), false);

    // recButton
    b = Button(win, Rect(col3, row2, 80, 80))
        .states_([
            ["rec", Color.black, Color.grey],
            ["recording", Color.black, Color.red],
        ])
        .action_({ |bu|
            if(bu.value == 0, {
                if(firstTime) {
                    loopTime = thisThread.clock.beats - startTime; 
                    synth.set(\loopTime, loopTime);
                    firstTime = false;
                };
                synth.set(\record, 0);
            });
            if(bu.value == 1, {
                if(firstTime) { startTime = thisThread.clock.beats };
                synth.set(\record, 1)
            });
        });

    // input1 slider
    StaticText(win, Rect(col1, row1, 10, 10)).font_(Font("Helvetica", 10)).string_("1");
    Slider(win, Rect(col1, row2, 20, 200))
        .action_({|in1| synth.set(\in1Mul, [0.0001, 1, \exp].asSpec.map(in1.value)) });
    // input2 slider
    StaticText(win, Rect(col2, row1, 10, 10)).font_(Font("Helvetica", 10)).string_("2");
    Slider(win, Rect(col2, row2, 20, 200)) 
        .action_({|in2| synth.set(\in2Mul, [0.0001, 1, \exp].asSpec.map(in2.value)) });
    win.onClose_({synth.free}).front;
)
