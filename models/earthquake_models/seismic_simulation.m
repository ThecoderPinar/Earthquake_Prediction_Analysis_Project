% Adım 1: Veriyi yükleme ve hazırlama
data = readtable('Earthquake_Prediction_Analysis_Project/earthquake_data.csv');
mag = data.mag;
depth = data.depth;
date_time = datetime(data.date_time);

% Adım 2: Örnekleme frekansını hesaplama
duration_seconds = seconds(date_time(end) - date_time(1)); % Toplam süreyi saniyeye dönüştürme
L = length(mag); % Veri uzunluğu
Fs = L / duration_seconds; % Örnekleme frekansı (Hz)

% Adım 3: FFT uygulama
Y = fft(mag); % FFT uygulama

% Adım 4: Frekans spektrumunu analiz etme
P2 = abs(Y/L); % Tek yan spektrumu hesapla
P1 = P2(1:L/2+1); % Tek yan spektrumu
P1(2:end-1) = 2*P1(2:end-1); % İlk ve son elemanları hariç iki katına çıkar
f = Fs*(0:(L/2))/L; % Frekans domaini oluştur

% Adım 5: FFT Sonuçlarını Görselleştirme
figure;
subplot(2,1,1);
plot(f,P1);
title('Single-Sided Amplitude Spectrum of Magnitude Data');
xlabel('Frequency (Hz)');
ylabel('|Magnitude|');

% Adım 6: Zaman Serisi Analizi
subplot(2,1,2);
plot(date_time, mag);
title('Magnitude Data over Time');
xlabel('Time');
ylabel('Magnitude');

% Adım 7: Regresyon Analizi
figure;
scatter(depth, mag);
title('Regression Analysis: Depth vs Magnitude');
xlabel('Depth');
ylabel('Magnitude');

% Adım 8: Makine Öğrenimi Modeli (Regresyon Modeli)
X = [ones(size(depth)) depth]; % Özellik matrisi (konstant ve derinlik)
[b, bint, r, rint, stats] = regress(mag, X); % Regresyon analizi

% Modelin katsayıları
intercept = b(1);
slope = b(2);

% R-kare değeri
R_squared = stats(1);

% Hata terimlerinin standart sapması
error_std = sqrt(stats(4));

% Modeli görselleştirme
figure;
scatter(depth, mag);
hold on;
plot(depth, intercept + slope * depth, 'r', 'LineWidth', 2);
xlabel('Depth');
ylabel('Magnitude');
title('Regression Analysis: Depth vs Magnitude');
legend('Data', 'Regression Line');

% Adım 9: Diğer Analizler

% Varyans Analizi
variance_depth = var(depth);
variance_mag = var(mag);

fprintf('Depth Variance: %.4f\n', variance_depth);
fprintf('Magnitude Variance: %.4f\n', variance_mag);


% Adım 10: Zaman Serisi Analizi ve Görselleştirme
figure;
plot(date_time, mag, 'b', 'LineWidth', 1.5);
title('Magnitude Time Series', 'FontSize', 14);
xlabel('Date Time', 'FontSize', 12);
ylabel('Magnitude', 'FontSize', 12);
datetick('x', 'yyyy-mm-dd'); % Tarih zaman eksenini biçimlendirme

% Adım 11: Veri Dağılımı Analizi ve Görselleştirme
figure;
subplot(2, 1, 1);
histogram(mag, 'Normalization', 'probability', 'FaceColor', 'blue');
title('Magnitude Histogram', 'FontSize', 14);
xlabel('Magnitude', 'FontSize', 12);
ylabel('Probability', 'FontSize', 12);

subplot(2, 1, 2);
histogram(depth, 'Normalization', 'probability', 'FaceColor', 'green');
title('Depth Histogram', 'FontSize', 14);
xlabel('Depth', 'FontSize', 12);
ylabel('Probability', 'FontSize', 12);

% Adım 12: İstatistiksel Özet Bilgileri
mag_mean = mean(mag);
mag_std = std(mag);
mag_min = min(mag);
mag_max = max(mag);

depth_mean = mean(depth);
depth_std = std(depth);
depth_min = min(depth);
depth_max = max(depth);

fprintf('Magnitude Statistics:\n');
fprintf('Mean: %.2f, Standard Deviation: %.2f, Min: %.2f, Max: %.2f\n', mag_mean, mag_std, mag_min, mag_max);

fprintf('Depth Statistics:\n');
fprintf('Mean: %.2f, Standard Deviation: %.2f, Min: %.2f, Max: %.2f\n', depth_mean, depth_std, depth_min, depth_max);

% Adım 13: Kutu Grafiği ile Görselleştirme
figure;
boxplot([mag, depth], 'Labels', {'Magnitude', 'Depth'});
title('Boxplot of Magnitude and Depth', 'FontSize', 14);
ylabel('Values', 'FontSize', 12);

% Adım 14: Yoğunluk Haritası Oluşturma
figure;
scatter(date_time, depth, 20, mag, 'filled');
colormap(jet); % Renk haritasını ayarla
colorbar; % Renk skalasını ekle
datetick('x', 'yyyy-mm-dd'); % Tarih zaman eksenini biçimlendirme
title('Depth vs. Time with Magnitude Color Mapping', 'FontSize', 12);
xlabel('Date Time', 'FontSize', 12);
ylabel('Depth', 'FontSize', 12);
caxis([min(mag) max(mag)]); % Renk skalasını ayarla

% Adım 15: Deprem Büyüklüğü ve Derinlik İlişkisi Scatter Plot
figure;
scatter(mag, depth, 50, 'b', 'filled');
title('Magnitude vs. Depth Scatter Plot', 'FontSize', 14);
xlabel('Magnitude', 'FontSize', 12);
ylabel('Depth', 'FontSize', 12);

% Ekstra adımlarınızı buraya ekleyebilirsiniz.



