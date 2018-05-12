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
    Out.ar(out, [input + tap, input + tap, tap]) // send delayed signal out on channel 2 for feeding back
}).add;

x = Synth(\test, [\buffer, ~buffer, \out, ~out, \in, ~in1]);
x.free;
b.free;

    (
    SynthDef("help-PinkNoise", { arg out=0; 
        Out.ar(out, PinkNoise.ar(0.1)) 
    }).send(s);

    SynthDef("help-In", { arg out=0, in=0;
        var input;
            input = In.ar(in, 1);
            Out.ar(out, input);
    }).send(s);

    )

    //play noise on the right channel

    x = Synth("help-PinkNoise", [\out, 1]);


    //read the input and play it out on the left channel

    Synth.after(x, "help-In", [\out, 0, \in, 1]); 