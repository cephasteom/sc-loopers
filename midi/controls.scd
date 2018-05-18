~isFirstTime = true;
~startTime;

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