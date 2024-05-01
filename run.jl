using Pkg
Pkg.activate(".")
using WAV
using UnicodePlots
using StableRNGs

fs = 44100 * 8 #TODO: play with this if we want! :) 

# After a bit of silence and the 10 second 770 Hz preamble,
preample_freq = 770
ten_sec = 0.0:(1 / fs):prevfloat(10.0)
y_preample = -1 .* sin.(2pi * preample_freq * ten_sec)
# wavplay(y_preample, fs)
first(y_preample)
last(y_preample)

# a SYNC Bit is detected. It may be difficult to see on figure 1, but the negative 
# part of the wave is smaller than the positive part.
# This is the combination of 2500 Hz and 2000 Hz half cycles I previously mentioned.
sync_a_freq = 2500
sync_a_num_seconds = (1 / sync_a_freq) / 2
sync_a_duration = 0:(1 / fs):prevfloat(sync_a_num_seconds)
y_sync_a = -1 .* sin.(2pi * sync_a_freq * sync_a_duration)
# wavplay(y_sync_a, fs)
lineplot(sync_a_duration, y_sync_a)
# lineplot(vcat(sync_a_duration, length(sync_a_duration):length(sync_a_duration)+9), vcat(y_sync_a, zeros(10)))
first(y_sync_a)
last(y_sync_a)

sync_b_freq = 2000
sync_b_num_seconds = (1 / sync_b_freq) / 2
sync_b_duration = 0:(1 / fs):prevfloat(sync_b_num_seconds)
y_sync_b = sin.(2pi * sync_b_freq * sync_b_duration)
# wavplay(y_sync_b, fs)
lineplot(sync_b_duration, y_sync_b)
first(y_sync_b)
last(y_sync_b)

y_header = vcat(y_preample, y_sync_a, y_sync_b)
lineplot(1:351, y_header[(length(y_header) - 350):length(y_header)])

# Garbage data!
rng = StableRNG(123)
y_white_noise = rand(rng, fs * 10) .- 0.5
lineplot(1:100, y_white_noise[1:100])
# wavplay(y_white_noise, fs)
# Save it! 
wavwrite(vcat(y_header, y_white_noise), "whitenoise.wav"; Fs=fs)

# Zero bit!
# a single 2000 Hz cycle to represent a zero and a single 1000 Hz cycle to represent a one
low_freq = 2000
low_freq_num_seconds = (1 / low_freq)
low_duration = 0:(1 / fs):prevfloat(low_freq_num_seconds)
y_low = -1 .* sin.(2pi * low_freq * low_duration)
# wavplay(y_sync_a, fs)
lineplot(low_duration, y_low)

# Zero bit!
# a single 2000 Hz cycle to represent a zero and a single 1000 Hz cycle to represent a one
high_freq = 1000
high_freq_num_seconds = (1 / high_freq)
high_duration = 0:(1 / fs):prevfloat(high_freq_num_seconds)
y_high = -1 .* sin.(2pi * high_freq * high_duration)
# wavplay(y_sync_a, fs)
lineplot(high_duration, y_high)

# Garbage binary data!
rng2 = StableRNG(123)
binary_garbage = rand(rng2, Bool, 200000)
y_binary_garbage = vcat(map(binary_garbage) do b
                            return b ? y_high : y_low
                        end...)
lineplot(1:100, y_binary_garbage[1:100])
# wavplay(y_white_noise, fs)
# Save it! 
wavwrite(vcat(y_header, y_binary_garbage), "binarynoise.wav"; Fs=fs)

# 30s high, then nothing
num_high_repeats = Int(floor(fs * 30 / length(y_high)))
y_high_repeats = vcat(fill(y_high, num_high_repeats)...)

lineplot(1:100, y_high_repeats[1:100])
# wavplay(y_white_noise, fs)
# Save it! 
wavwrite(vcat(y_header, y_high_repeats), "high30s.wav"; Fs=fs)

# 30s binary noise, then nothing
rng3 = StableRNG(123)
y_rand30s = Float64[]
while length(y_rand30s) <= 30 * fs
    y_rand = rand(rng3, [y_high, y_low])
    append!(y_rand30s, y_rand)
end
y_rand30s / 353
wavwrite(vcat(y_header, y_rand30s), "rand30s.wav"; Fs=fs)
