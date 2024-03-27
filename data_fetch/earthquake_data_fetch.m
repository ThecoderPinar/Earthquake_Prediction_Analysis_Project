function earthquake_data_fetch()
    % API'den veri çekme işlemi
    url = 'https://api.orhanaydogdu.com.tr/deprem/kandilli/live';
    options = weboptions('ContentType', 'json');
    response = webread(url, options);

    % API'den gelen verilerin kontrolü
    if isempty(response)
        error('API verisi alınamadı.');
    end

    % Veri işleme ve analiz için örnek adımlar
    % Örneğin, gelen verilerin ilk 5 öğesini yazdıralım
    disp('İlk 5 deprem verisi:');
    disp(response(1:5));
end
