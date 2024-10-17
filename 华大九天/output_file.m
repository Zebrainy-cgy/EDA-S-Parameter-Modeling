function output_file(poles,R,D)%输入分别为极点，留数，常数项
    fileID = fopen('eda240731_model.dat', 'w');
    complex_poles = [];
    complex_R = [];
    real_poles = [];
    real_R = [];

    % 自动识别实数和复数
    for i = 1:length(poles)
        if imag(poles(i)) ~= 0  % 如果虚部不为零，则为复数
            complex_poles = [complex_poles; poles(i)];  % 添加到复极点数组
            complex_R = [complex_R; R(:,:,i)];
        else
            real_poles = [real_poles; poles(i)];  % 添加到实极点数组
            real_R = [real_R; R(:,:,i)];
        end
    end

    % 计算总极点数、复共轭极点对数和实极点数
    Nq = length(complex_poles) + length(real_poles);  % 总极点数
    Nqc = length(complex_poles) / 2;  % 复共轭极点的对数
    Nqr = length(real_poles);  % 实极点数

    % 写入标识符和极点数信息
    fprintf(fileID, 'Poles %d %d %d\n', Nq, Nqc, Nqr);

    % 写入复极点的实部和虚部
    for i = 1:Nqc
        fprintf(fileID, '%.6f %.6f\n', real(complex_poles(2*i-1)), imag(complex_poles(2*i-1)));
        fprintf(fileID, '%.6f %.6f\n', real(complex_poles(2*i)), imag(complex_poles(2*i)));
    end

    % 写入实极点
    for i = 1:Nqr
        fprintf(fileID, '%.6f\n', real(real_poles(i)));
    end
    
    M = size(R,1);
    % 写入标识符和端口数 M
    fprintf(fileID, 'Residues %d\n',M);
    
    for i = 1:Nqc*2
        for j = 1:M
            for k = 1:M
                fprintf(fileID, '%.6f %.6f ', real(complex_R(j, k)), imag(complex_R(j, k)));
            end
        end
        fprintf(fileID, '\n');  % 每行结束后换行
    end

    for i = 1:Nqr
        for j = 1:M
            for k = 1:M
                fprintf(fileID, '%.6f ', real_R(j, k));
            end
        end
        fprintf(fileID, '\n');  % 每行结束后换行
    end
    
    % 写入标识符和端口数 M
    fprintf(fileID, 'Hinf %d\n',M);

    for j = 1:M
        for k = 1:M
            fprintf(fileID, '%.6f ', D(j,k));
        end
    end
    % 关闭文件
    fclose(fileID);