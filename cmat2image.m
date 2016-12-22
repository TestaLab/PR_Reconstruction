function reconstructed = cmat2image(cmat, presets)

    nulls_x = presets.nulls_x;
    nulls_y = presets.nulls_y;

    fr_p_line = sqrt(size(cmat, 2));
    nnulls = nulls_y*nulls_x;
    subsquares = zeros(fr_p_line, fr_p_line, nnulls);
    for i = 1:nnulls
        subsquare = reshape(cmat(i,:), fr_p_line, fr_p_line);
        subsquare(:,1:2:end) = flipud(subsquare(:,1:2:end));
        subsquare = rot90(subsquare,2);
        subsquares(:,:,i) = subsquare;
    end
    reconstructed = zeros((nulls_y-2)*fr_p_line, nulls_x*fr_p_line);
    yind = 1;
    xind = 1;

    for x = 1:nulls_x
        for y = 1:nulls_y
            xr = xind:xind+fr_p_line-1;
            yr = yind:yind+fr_p_line-1;
            reconstructed(yr, xr) = subsquares(:,:,(x-1)*nulls_y + y);
            yind = yind + fr_p_line;
        end
        yind = 1;
        xind = xind + fr_p_line;
    end
    %%Handle the sometimes not representable frame values
    %Make image w/o the frame
    wo_frame = reconstructed(1+fr_p_line:end-fr_p_line, 1+fr_p_line:end-fr_p_line);
    minvalue = min(wo_frame(:));
    maxvalue = max(wo_frame(:));

    reconstructed = wo_frame;
end