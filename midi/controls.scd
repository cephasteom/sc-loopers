// TODO: set up with nano controller, ie these channels are just rough...
~isFirstTime = true;
~startTime;

MIDIdef.cc(\looperControls, {
	arg val, chan, src; 
	// [val, chan, src].postln;
	if(chan == 0, { // start recording / overdubbing
		if(~isFirstTime, { ~startTime = thisThread.clock.beats; })
		~looperSynth1.set(\inMul, 1); 
	}); 
	if(chan == 1, { // mute input
		if(~isFirstTime, { // if first loop set loop time
			~looperSynth1.set(\loopTime, thisThread.clock.beats - ~startTime);
			~isFirstTime = false;
		})
		~looperSynth1.set(\inMul, 0) 
	}); // stop recording
	if(chan == 2, {});
	if(chan == 3, {});
	if(chan == 4, {});
	if(chan == 5, {});
	if(chan == 6, {});
	if(chan == 7, {});
	if(chan == 8, {});
})