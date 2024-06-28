%% This script plots data saved from the Particle Detection App.

% Loading the file into MatLab
[file, path] = uigetfile('*.mat', 'Load File');
if file
    load([path, '\', file], 'ParticleData', 'variables');
else
    return;
end

cumulativeParticleSize = variables{12};
numParticles = variables{13};

%% Display The Number of Particles
ax = axes;
bar(ax, numParticles, 1);
ax.XLim = [0.5, length(numParticles) + 0.5];

%% Display Cumulative Particle Size
fig = figure(2);
histogram(cumulativeParticleSize);