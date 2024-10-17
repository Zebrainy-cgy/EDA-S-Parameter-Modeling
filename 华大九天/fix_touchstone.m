function fix_touchstone(filename_in, filename_out)
    fid_in = fopen(filename_in, 'r');
    fid_out = fopen(filename_out, 'w');

    while ~feof(fid_in)
        line = fgetl(fid_in);
        if isempty(line) || line(1) == '!' || line(1) == '#'
            % 如果是注释行或元数据行，直接写入
            fprintf(fid_out, '%s\n', line);
        else
            % 处理数据行
            data = str2num(line);  % 转换为数字数组
            if length(data) > 9  % 如果超过了1个频率 + 4对数据 = 9个元素
                freq = data(1);
                params = data(2:end);
                fprintf(fid_out, '%e ', freq);  % 写入频率
                fprintf(fid_out, '%e ', params(1:4));  % 每行最多写4对数据
                fprintf(fid_out, '\n');
                for i = 5:4:length(params)
                    % fprintf(fid_out, '%e ', freq);  % 写入频率
                    fprintf(fid_out, '%e ', params(i:min(i+3,length(params))));  % 每行最多写4对数据
                    fprintf(fid_out, '\n');
                end
            else
                % 如果数据不超过限制，直接写入
                fprintf(fid_out, '%s\n', line);
            end
        end
    end

    fclose(fid_in);
    fclose(fid_out);
end
