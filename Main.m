clear,clc;

% log file
log_file_id = fopen('log_file','w');

%   paths:
Input_Video_Path = '.\InputVideos\';

%   parameters:
Sub_Sequence_Length = 5;
Threshold_tau = 0.994;

File_List = ls(Input_Video_Path);
File_List(1:2,:) = [];
File_List_Width = size(File_List,2);
for fileloop = 1:size(File_List,1)
    t_whole = tic;
    %   parse file name
    Cur_File_Full_Name = File_List(fileloop,:);
    Reversed_Full_Name = Cur_File_Full_Name(end:-1:1);
    Dot_Position = strfind(Reversed_Full_Name, '.');
    Dot_Position = File_List_Width - Dot_Position + 1;
    Blank_Position = strfind(Cur_File_Full_Name, ' ');
    if isempty(Blank_Position)
        Ext_Length = File_List_Width - Dot_Position;
    else
        Ext_Length = Blank_Position(1) - Dot_Position - 1;
    end
    Cur_File_Name = Cur_File_Full_Name(1:Dot_Position - 1);
    File_Ext = Cur_File_Full_Name(Dot_Position:Dot_Position + Ext_Length);
    Cur_File_Full_Name = [Input_Video_Path Cur_File_Name File_Ext];
    
    %   read video file
    Cur_Vid_Obj = VideoReader(Cur_File_Full_Name);
    Vid_Height = Cur_Vid_Obj.Height;
    Vid_Width = Cur_Vid_Obj.Width;
    Num_of_Frames = Cur_Vid_Obj.NumberOfFrames;
    scaler = 0.25;
    tmp_frame = read(Cur_Vid_Obj,1);
    tmp_frame = imresize(tmp_frame, scaler);
    [Vid_Height, Vid_Width, Vid_Channels] = size(tmp_frame);
    Cur_Frames_Gray = zeros(Vid_Height, Vid_Width, Num_of_Frames, 'uint8');
    
    
    t_frame_extraction = tic;
    for i = 1:Num_of_Frames
        tmp_frame = read(Cur_Vid_Obj,i);
        tmp_frame = imresize(tmp_frame,scaler);
%         tmp_frame(:,:,1) = normalize_matrix2(double(tmp_frame(:,:,1)));
%         tmp_frame(:,:,2) = normalize_matrix2(double(tmp_frame(:,:,2)));
%         tmp_frame(:,:,3) = normalize_matrix2(double(tmp_frame(:,:,3)));
        Cur_Frames_Gray(:,:,i) = rgb2gray(tmp_frame);
    end
    clear tmp_frame;
    t_frame_extraction = toc(t_frame_extraction);
    fprintf('frame extraction: %f seconds...\n', t_frame_extraction);
    
    %   Levenshtein Distance computation and duplication verification detection
    Identical_Frame_Pairs = zeros(0,2);
    Leven_Distances_Of_Frames = zeros(1,Sub_Sequence_Length);
    for frameloopi = 1:Num_of_Frames - Sub_Sequence_Length + 1
        %fprintf('Extracting subsequence from frame %d ...\n',frameloopi);
        Sub_Sequence_Sample = Cur_Frames_Gray(:,:,frameloopi:frameloopi + Sub_Sequence_Length - 1);
        for frameloopj = frameloopi + Sub_Sequence_Length : Num_of_Frames - Sub_Sequence_Length + 1
            Sub_Sequence_Ref = Cur_Frames_Gray(:,:,frameloopj:frameloopj + Sub_Sequence_Length - 1);
            for subseqloop = 1:Sub_Sequence_Length
                %fprintf('Checking frame %d ...\n',frameloopj+subseqloop-1);
                Leven_Distances_Of_Frames(subseqloop) = ImprovedLevenDist(Sub_Sequence_Sample(:,:,subseqloop),Sub_Sequence_Ref(:,:,subseqloop));
                if Leven_Distances_Of_Frames(subseqloop) ~=0 
                    break;
                end
            end
            if subseqloop == Sub_Sequence_Length && Leven_Distances_Of_Frames(subseqloop) == 0
                %fprintf('Alarm at frame pair %d and %d ...\n',frameloopi, frameloopj);
                Identical_Frame_Pairs = [Identical_Frame_Pairs; [frameloopi:frameloopi + Sub_Sequence_Length - 1]' [frameloopj:frameloopj + Sub_Sequence_Length - 1]'];
                Identical_Frame_Pairs = unique(Identical_Frame_Pairs, 'rows');
            end
        end
    end
    t_whole = toc(t_whole);
    %   report results
    if ~isempty(Identical_Frame_Pairs)
        fprintf(log_file_id,'Identical frame pairs in %s: , elapsed time: %f...\n',Cur_File_Full_Name, t_whole);
        for z = 1:size(Identical_Frame_Pairs,1)
            fprintf(log_file_id, '%d - %d\t', Identical_Frame_Pairs(z,1),Identical_Frame_Pairs(z,2));
            if mod(z,10) == 0
                fprintf(log_file_id, '\n');
            end
        end
    end
    fprintf(log_file_id,'\n-----------------------------------------------------------------\n');
end %end of fileloop


