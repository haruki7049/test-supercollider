(
var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
    .numInputBusChannels_(2)
);

a = Score([
    [0.0, ['/d_recv',
        SynthDef(\NRTsine, { |out, freq = 440|
            Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
        }).asBytes
    ]],
    [0.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 800])],
    [2.0, x.freeMsg]
]);

a.recordNRT(
    outputFilePath: "output.wav".standardizePath,
    headerFormat: "wav",
    sampleFormat: "int24",
    options: server.options,
    duration: 2,
    action: { "done".postln }
);

server.remove;

0.exit;
)
