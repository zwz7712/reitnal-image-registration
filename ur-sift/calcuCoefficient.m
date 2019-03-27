function accumSigma = calcuCoefficient( iniSigma, octave, layer )
%   �����Ӧ�߶ȵĳ߶�ϵ��
    k = 2^(1/layer);
    accumSigma = zeros(octave,layer);
    for oct = 1:octave
        for lay = 1:layer
            accumSigma(oct,lay) = iniSigma*k^(layer*(oct-1)+lay);
        end
    end

end

