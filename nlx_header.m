function hdr = nlx_header(filename)
%NLX_HEADER   Read a Neuralynx CSC file header.
%
%  hdr = nlx_header(filename)

hdr = Nlx2MatCSC_v3(filename, [0 0 0 0 0], 1, 2, [0 0]);
