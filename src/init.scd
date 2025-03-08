(
var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
    .numInputBusChannels_(2)
);

a = Score.new([
    [0, ['/d_recv',
        SynthDef(\NRTsine, { |out, freq = 440|
            Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
        }).asBytes
    ]],
    [0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 800])],
    [1, x.freeMsg],

    [1, (y = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 600])],
    [2, y.freeMsg]
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
