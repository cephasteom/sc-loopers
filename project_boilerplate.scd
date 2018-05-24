s.quit;

// **********************************************************************
// 1. SERVER CONFIG - any server setup key to this piece
// **********************************************************************

// read ServerOptions help file for properties of s.options
s = Server.local;
// s.options.outDevice_('Built-in Output'); // home
// s.options.inDevice_('Built-in Microph'); // home
s.options.device = "DN32-USB"; // studio
// s.options.numOutputBusChannels_(4); // outs 0 - 3 home
s.options.numOutputBusChannels_(8); // outs 0 - 3 studio
// s.options.numInputBusChannels_(2); // ins 4-5 (or 1... if using SoundIn.ar) home
s.options.numInputBusChannels_(8); // ins 4-5 (or 1... if using SoundIn.ar) studio
s.options.sampleRate_(48000);
s.options.memSize_(2.pow(20)); // roughly 1 gig of realtime memory
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// **********************************************************************
// 2. INIT GLOBAL VARIABLES
// **********************************************************************
// outs
~out = 0;
~tapBus1 = 2;
// ~projectPath = "/Users/Pete/Documents/my-coding/supercollider/projects/project_loopers"; // home
~projectPath = "/Users/petethomas/code/project_loopers"; // studio
~synthsPath = ~projectPath++"/synths";
~midiPath = ~projectPath++"/midi";
~guiPath = ~projectPath++"/gui";

// **********************************************************************
// 3. DEFINE PIECE SPECIFIC FUNCTIONS
// **********************************************************************
~makeBuffers = {
	// ~looperBuf1 = Buffer.alloc(s, 44100 * 20, 1); // a 20 second 1 channel Buffer
	// ~looperBuf1MaxDelay = ~looperBuf1.numFrames / ~looperBuf1.sampleRate;
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
	// ~mainGroup = Group.new;
	// ~reverbGroup = Group.after(~mainGroup);

	// define more fx nodes as you need them
};
~makeGui = {
	// MIDIIn.connectAll
	g = Dictionary.new;
	g.add(\looperGui -> (~guiPath++"/looper_gui.scd").load);
	
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
	ServerTree.add(~makeGui); 
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
// args in1, in2, out, tapBus
// g[\looperGui].value(0, 1, ~out, ~tapBus1);


