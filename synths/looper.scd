// definition of the looper
SynthDef(\looper, {
    // need a buffer to listen to and an input for the loop trigger
    arg bufnum, t_reset, rate=1, out=0, in=0, record=1, vol=1;

    var inputSig, outputSig, existingSig, recHead;

    // get the input signal
    inputSig = SoundIn.ar(in, record);

    // generate the recording (also playback) position
    recHead = Phasor.ar(t_reset, BufRateScale.kr(bufnum) * rate, 0, BufFrames.kr(0));

    // read the existing signal from the loop
    existingSig = BufRd.ar(1, bufnum, recHead);

    // put the existing signal plus the new signal into the loop
    BufWr.ar(inputSig + existingSig, bufnum, recHead);

    // play back signal we got from the loop before the writing operation
    Out.ar(out, existingSig!2*vol);
}).add;

// // create a big empty buffer (20 secs is enough for me)
// b = Buffer.alloc(s, 20 * s.sampleRate, 1);

// // create an instance of the looper
// ~looper = Synth.new(\looper, [\bufnum, b.bufnum]);
// ~looper.trace;

// ~looper.set(\t_reset, 1);
// ~looper.set(\rate, 0.5);
// ~looper.free;
// b.free;

// t = Task({{ ~looper.set(\t_reset, 1); 1.wait;}.loop }).start;
// t.stop