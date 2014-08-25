function [ACQsampleRate,ACQtimeAxis,chanData] = readACQFile(filename)
   acq = load_acq([filename '.acq']);
   ACQsampleRate = 1000/acq.hdr.graph.sample_time;
   ACQnumberSamples = acq.hdr.per_chan_data(1).buf_length;
   ACQtimeAxis = linspace(0, (ACQnumberSamples-1)/ACQsampleRate, ACQnumberSamples);
   chanData = acq.data';
end
