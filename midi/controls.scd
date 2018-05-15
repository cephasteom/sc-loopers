// TODO: set up with nano controller, ie these channels are just rough...
~isFirstTime = true;
~startTime;
~looperBuf1MaxDelay = ~looperBuf1.numFrames / ~looperBuf1.sampleRate;

MIDIdef.cc(\looperControls, {
	arg val, chan, src; 
	[val, chan, src].postln;
	if(chan == 45, { // start recording / overdubbing
		if(~isFirstTime, { 
			~looperBuf1.zeroMsg(); // clear buffer
			~startTime = thisThread.clock.beats; // set start time
		});
		~looperSynth1.set(\record, 1); 
	}); 

	if(chan == 1, { // stop recording
		if(~isFirstTime, { // if first loop set loop time
			~elapsedTime = thisThread.clock.beats - ~startTime;
			if(~elapsedTime < ~looperBuf1MaxDelay, { ~looperSynth1.set(\loopTime, ~elapsedTime) } );
			~isFirstTime = false;
		});
		~looperSynth1.set(\record, 0);
	});

	if(chan == 2, { ~looperSynth1.set(\inMul, val.linexp(1, 127, 0.0, 1.0)); }); // adjust volume input 1
	if(chan == 3, { ~looperSynth1.set(\inMul2, val.linexp(1, 127, 0.0, 1.0)); }); // adjust volume input 2
	if(chan == 4, { ~looperSynth1.set(\loopMul, val.linexp(1, 127, 0.0, 1.0)); }); // adjust volume loop
	if(chan == 5, { // clear instantly
		~looperSynth1.set(\record, 0); // if recording stop
		~looperBuf1.zeroMsg('Buffer cleared'); // clear buffer
		~isFirstTime = true; // set flag to start process again on next round
	}); 
	if(chan == 6, { ~isFirstTime = true; }); // reset on next record
});

MIDIdef.cc(\looperControls, {
	arg val, chan, src; 
	[val, chan, src].postln;
});
