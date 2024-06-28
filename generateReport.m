function generateReport(filepath, filename, data)
%% Setup
word = actxserver('Word.Application');
word.Visible =1;
document = word.Documents.Add;
selection = word.Selection;
selection.Font.Name = 'Times New Roman';

selection.Pagesetup.RightMargin=28.34646;   %set right Margin to 1cm
selection.Pagesetup.LeftMargin=28.34646;    %set left Margin to 1cm
selection.Pagesetup.TopMargin=28.34646;     %set top Margin to 1cm
selection.Pagesetup.BottomMargin=28.34646;  %set bottom Margin to 1cm

selection.Paragraphs.LineUnitAfter=0.01;

%% Variables
numParticlesData = data.numParticles;
cumulativeParticleSizeData = data.particleSize;
aveIntensityData = data.aveIntensity;
peakIntensityData = data.peakIntensity;
combinedData = data.combinedStats;

%% Title
selection.ParagraphFormat.Alignment = 1;
selection.Font.Size = 14;
selection.Font.Bold = 1;
for i = 1:5
    selection.TypeParagraph;
end
selection.TypeText('Particle Detection Application');
selection.TypeParagraph; selection.TypeParagraph;
selection.TypeText('Version 1.0');
selection.Font.Bold = 0;
selection.InsertNewPage;
%% Number of Particles
selection.ParagraphFormat.Alignment = 0;
selection.Font.Size = 11;
selection.Font.Bold = 0;
total = 0;
for i = 1:length(numParticlesData)
    total = total + numParticlesData(i);
end
selection.TypeText(['Total Number of Particles Detected: ', num2str(total)]);
selection.TypeParagraph;

fig = figure(1);
numParticlesGraph = axes(fig);
plot(numParticlesGraph, numParticlesData);
xlabel('Image');
ylabel('Number of Particles');
print(fig, '-dmeta');
invoke(word.Selection, 'Paste');
close Figure 1;
selection.TypeParagraph;

%% Particle Size
meanSize = mean(cumulativeParticleSizeData(:));
selection.TypeText(['Mean Particle Size: ', num2str(meanSize)]);
selection.TypeParagraph;
fig = figure;
sizeParticlesGraph = axes(fig);
histogram(sizeParticlesGraph, cumulativeParticleSizeData);
xlabel('Particle Size (Pixels)');
ylabel('Number of Particles');
print(fig, '-dmeta');
invoke(word.Selection, 'Paste');
close Figure 1;
selection.InsertNewPage;

%% Average Intensity
meanInt = mean(aveIntensityData(:));
selection.TypeText(['Mean Average Intensity: ', num2str(meanInt)]);
selection.TypeParagraph;
fig = figure;
aveIntensityGraph = axes(fig);
histogram(aveIntensityGraph, aveIntensityData);
xlabel('Particle Intensity');
ylabel('Number of Particles');
print(fig, '-dmeta');
invoke(word.Selection, 'Paste');
close Figure 1;
selection.TypeParagraph;

%% Peak Intensity
meanPeakInt = mean(peakIntensityData(:));
selection.TypeText(['Mean Peak Intensity: ', num2str(meanPeakInt)]);
selection.TypeParagraph;
fig = figure;
peakIntensityGraph = axes(fig);
histogram(peakIntensityGraph, peakIntensityData);
xlabel('Particle Intensity');
ylabel('Number of Particles');
print(fig, '-dmeta');
invoke(word.Selection, 'Paste');
close Figure 1;
selection.InsertNewPage;

%% Combined Stats
for i = 1:4
    maxe(i) = max(combinedData(:,i));
    combinedData(:,i) = combinedData(:,i)/max(combinedData(:,i));
end
selection.TypeText(['Max Number of Particles: ', num2str(maxe(1))]);
selection.TypeParagraph;
selection.TypeText(['Max Average Particle Size: ', num2str(maxe(2))]);
selection.TypeParagraph;
selection.TypeText(['Max Average Particle Intensity: ', num2str(maxe(3))]);
selection.TypeParagraph;
selection.TypeText(['Max Average Peak Intensity: ', num2str(maxe(4))]);
selection.TypeParagraph;
fig = figure;
combinedGraph = axes(fig);
plot(combinedGraph, combinedData);
combinedGraph.XLim = [0.5,length(combinedData(:,1))+0.5];
legend(combinedGraph, ['Number of Particles /',num2str(maxe(1))], ['Average Particle Size /',num2str(maxe(2))], ...
                    ['Average Intensity /',num2str(maxe(3))], ['Average Peak Intensity /',num2str(maxe(4))]);
xlabel('Image');
ylabel('Value / Max');
print(fig, '-dmeta');
invoke(word.Selection, 'Paste');
close Figure 1;

%% Save
document.SaveAs2([filepath,filename, '.pdf'], 17);
document.SaveAs2([filepath,filename, '.docx']);
document.Close;
word.Quit();