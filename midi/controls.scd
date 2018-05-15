~isFirstTime = true;
~startTime;
~looperBuf1MaxDelay = ~looperBuf1.numFrames / ~looperBuf1.sampleRate;

~looperSynth1 = Synth(\looper, 
	[\buffer, ~looperBuf1, \outBus, ~out, \inBus, ~in1, \loopTime, ~looperBuf1MaxDelay-0.1], 
	~mainGroup
);

MIDIdef.cc(\looperControls, {
	arg val, chan, src; 
	[val, chan, src].postln;
	// strip note offs
	if(val > 0, {
		if(chan == 45, { // start recording / overdubbing
			if(~isFirstTime, { ~record.value }, { ~punchIn.value });
		}); 

		if(chan == 41, { // stop recording
			if(~isFirstTime, { ~loopIt.value }, { ~punchOut.value });
		});
	});

	if(chan == 0, { ~looperSynth1.set(\inMul, val.linexp(1, 127, 0.001, 1.0)); }); // adjust volume input 1
	if(chan == 1, { ~looperSynth1.set(\inMul2, val.linexp(1, 127, 0.001, 1.0)); }); // adjust volume input 2
	if(chan == 2, { ~looperSynth1.set(\loopMul, val.linexp(1, 127, 0.001, 1.0).postln); }); // adjust volume loop
	// if(chan == 5, { // clear instantly
	// 	~looperSynth1.set(\record, 0); // if recording stop
	// 	~looperBuf1.zeroMsg('Buffer cleared'); // clear buffer
	// 	~isFirstTime = true; // set flag to start process again on next round
	// }); 
	// if(chan == 6, { ~isFirstTime = true; }); // reset on next record
});

~record = {
	'record'.postln;
	~looperBuf1.zeroMsg(); // clear buffer
	~startTime = thisThread.clock.beats; // set start time
	~looperSynth1.set(\record, 1); 
};

~loopIt = {
	~elapsedTime = thisThread.clock.beats - ~startTime;
	if(~elapsedTime < ~looperBuf1MaxDelay, { ~looperSynth1.set(\loopTime, ~elapsedTime) } );
	~isFirstTime = false;
	~looperSynth1.set(\record, 0);
} ;

~punchIn = { 
	'PunchIn'.postln;
	~looperSynth1.set(\record, 1);
};

~punchOut = { 
	'PunchOut'.postln;
	~looperSynth1.set(\record, 0);
};

// MIDIdef.freeAll