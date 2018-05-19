s.quit;

// **********************************************************************
// 1. SERVER CONFIG - any server setup key to this piece
// **********************************************************************

// read ServerOptions help file for properties of s.options
s = Server.local;
s.options.outDevice_('Built-in Output');
s.options.numOutputBusChannels_(4); // outs 0 - 3
s.options.inDevice_('Built-in Microph');
s.options.numInputBusChannels_(2); // ins 4-5
s.options.sampleRate_(44100);
s.options.memSize_(2.pow(20)); // roughly 1 gig of realtime memory
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// **********************************************************************
// 2. INIT GLOBAL VARIABLES
// **********************************************************************
~out = 0;
~in1 = 4; 
~in2 = 5; 
TempoClock.default.tempo = 104 / 60;
~projectPath = "/Users/Pete/Documents/my-coding/supercollider/projects/project_loopers";
~synthsPath = ~projectPath++"/synths";
~midiPath = ~projectPath++"/midi";

// **********************************************************************
// 3. DEFINE PIECE SPECIFIC FUNCTIONS
// **********************************************************************
~makeBuffers = {
	~looperBuf1 = Buffer.alloc(s, 44100 * 20, 1); // a 20 second 1 channel Buffer
	~looperBuf1MaxDelay = ~looperBuf1.numFrames / ~looperBuf1.sampleRate;
};

~makeBusses = {
	~busses = Dictionary.new;
	~busses.add(\reverb -> Bus.audio(s, 2));
	// add more busses as you need them
};

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~makeNodes = {
	~mainGroup = Group.new;
	~reverbGroup = Group.after(~mainGroup);

	// define more fx nodes as you need them
};
~makeMidi = {
	MIDIIn.connectAll;
	e = Dictionary.new;
	e.add(\controls -> (~midiPath++"/controls.scd").load);
};

// **********************************************************************
// 4. REGISTER FUNCTIONS WITH ABSTRACT SERVER ACTION
// **********************************************************************
ServerBoot.add(~makeBuffers); // make ~buffers
ServerBoot.add(~makeBusses); // make ~busses
ServerQuit.add(~cleanup); // clean up when quit the server

// **********************************************************************
// 5. BOOT SERVER
// **********************************************************************
s.waitForBoot({
	s.sync; // ensure actions have completed before moving on (synchronous)
	// 5a. REGISTER SYNTHDEFS
	(~synthsPath++"/tapDelay.scd").load;
	s.sync;
	// load state
	(~projectPath++"/data.scd").load;
	// 5b. CREATE NODES AND EVENTS
	ServerTree.add(~makeNodes); // delay these until you've created your nodes
	// TODO: add controls back in
	// ServerTree.add(~makeMidi); 
	s.freeAll;
	s.sync;
	// s.plotTree;
	s.meter;
	// 5c. NOW READY TO BEGIN PERFORMANCE
	"Done".postln;
});

// **********************************************************************
// 6. PERFORMANCE
// **********************************************************************

// UNCOMMENT TO RUN GUI
(
    var synth, win, buttons, firstTime, startTime, loopTime, cols, rows, bsize;
    firstTime=true;
    startTime=0;
    cols = 2; rows = 2;
    bsize = 80;
    // synth
    synth = Synth(\looper, [\buffer, ~looperBuf1, \outBus, ~out]);
    // GUI window
    win = Window(\looper, Rect(0, 0, 500, 500), false);

    buttons = [0,1,2,3];
    buttons = buttons.collect({|i| Button(win, Rect((i % cols) * bsize, trunc(i/cols) * bsize, bsize, bsize))});

    // rec button
	buttons[0].states_([
		["rec", Color.black, Color.new(136/255, 80/255, 83/255)],
		["recording", Color.black, Color.new(254/255, 95/255, 85/255)],
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

	// erase button
	buttons[1].states_([
        ["clear", Color.black, Color.new(119/255, 125/255, 167/255)],
    ])
    .action_({ arg bu;
        buttons[0].valueAction = 0;
        synth.set(\loopTime, 19.9);
        // TODO: make all of this a function and pass it on
        ~looperBuf1.zero(); // clear buffer
        firstTime = true;
    });


    // // input1 slider
    // StaticText(win, Rect(col1, row1, 10, 10)).font_(Font("Helvetica", 10)).string_("1");
    // Slider(win, Rect(col1, row2, 20, 170))
    //     .action_({|in1| synth.set(\in1Mul, [0.0001, 1, \exp].asSpec.map(in1.value)) });
    // // input2 slider
    // StaticText(win, Rect(col2, row1, 10, 10)).font_(Font("Helvetica", 10)).string_("2");
    // Slider(win, Rect(col2, row2, 20, 170)) 
    //     .action_({|in2| synth.set(\in2Mul, [0.0001, 1, \exp].asSpec.map(in2.value)) });
    win.onClose_({synth.free}).front;
)
