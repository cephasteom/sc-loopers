// write a signal into a delay, tap it at multiple times
SynthDef(\test, { |out=0, in=4, buffer|
    var input, loop, tapPhase, delay, tap;
    input = In.ar(in, 1); // internal mic, this needs to mute when not overdubbing
    delay = InFeedback.ar(2, 1); // delay
    tapPhase = DelTapWr.ar(buffer, input + delay);
    tap = DelTapRd.ar(buffer, tapPhase,
        3.9, // tap time
        1, // no interp
        1.0 // muls for each tap
    );
    OffsetOut.ar(2, DelayC.ar(tap, 1, 440.reciprocal - ControlRate.ir.reciprocal)); // subtract block size, send tap out of channel 2 to be fed back
    OffsetOut.ar(out, [input + tap, input + tap]) // send delayed signal out on channel 2 for feeding back
}).add;

x = Synth(\test, [\buffer, ~buffer, \out, ~out, \in, ~in1]);
x.free;
b.free;

// general code flexibility, ability to do routing on implementation
// block size delay...
// be able to mute and un mute mic
// handling of loop time

    (

    var play, imp, initial;

    SynthDef("testRes", {

    

    play = InFeedback.ar(10, 1); // 10 is feedback channel

    imp = Impulse.ar(1);

    

    // feedback

    

    

    OffsetOut.ar(0, play);

    

    }).play(s);

    

    // Compare with this for tuning

    { SinOsc.ar(440, 0, 0.2) }.play(s, 1);

    )