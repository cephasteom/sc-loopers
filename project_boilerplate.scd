s.quit;

// **********************************************************************
// 1. SERVER CONFIG - any server setup key to this piece
// **********************************************************************

// read ServerOptions help file for properties of s.options
s = Server.local;
s.options.outDevice_('Built-in Output');
s.options.numOutputBusChannels_(2);
s.options.inDevice_('Built-in Microph');
s.options.numInputBusChannels_(2);
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
TempoClock.default.tempo = 104 / 60;
~buffers; // populated by ~makeBuffers function on ServerBoot
~projectPath = "/Users/Pete/Documents/my-coding/supercollider/projects/project_boilerplate";
~buffersPath = ~projectPath++"/buffers";
~synthsPath = ~projectPath++"/synths";

// **********************************************************************
// 3. DEFINE PIECE SPECIFIC FUNCTIONS
// **********************************************************************
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
	~reverbSynth = Synth.new(
		\customReverb,
		[
			\in, ~busses[\reverb],
			\out, ~out,
		],
		~reverbGroup
	);
	// define more fx nodes as you need them
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
	(~synthsPath++"/synth-custom-reverb.scd").load;
	s.sync;
	// load state
	(~projectPath++"/data.scd").load;
	// 5b. CREATE NODES AND EVENTS
	ServerTree.add(~makeNodes); // delay these until you've created your nodes
	ServerTree.add(~makeEvents); // delay these until you've created your events
	s.freeAll;
	s.sync;
	s.plotTree;
	s.meter;
	// 5c. NOW READY TO BEGIN PERFORMANCE
	"Done".postln;
});

// **********************************************************************
// 6. PERFORMANCE
// **********************************************************************

// s.quit;
