% Adım 1: Veriyi yükleme ve hazırlama
data = readtable('Earthquake_Prediction_Analysis_Project/earthquake_data.csv');
X = [data.mag, data.depth]; % Giriş özellikleri
Y = data.mag; % Tahmin edilecek değerler

% Adım 2: Model Seçimi ve Hiperparametre Ayarları
model = fitrsvm(X, Y, 'KernelFunction', 'gaussian', 'OptimizeHyperparameters', 'auto');

% Adım 3: Modelin Doğrulanması ve Performans Metriklerinin Hesaplanması
cv_model = crossval(model);
mse = kfoldLoss(cv_model); % Ortalama kare hatası

% Adım 4: Detaylı Analizler
% Modelin performans metriklerini hesaplayabiliriz
Y_pred = predict(model, X);
accuracy = sum(Y_pred == Y) / length(Y); % Doğruluk oranı
precision = sum(Y_pred & Y) / sum(Y_pred); % Hassasiyet
recall = sum(Y_pred & Y) / sum(Y); % Geri çağırma
f1_score = 2 * (precision * recall) / (precision + recall); % F1 skoru

% Adım 5: 3D Görselleştirme
figure;
scatter3(data.mag, data.depth, data.mag, 'filled');
xlabel('Magnitude');
ylabel('Depth');
zlabel('Target Variable');
title('3D Visualization of Seismic Activity');

% Modeli kullanarak tahminler yapma
Y_pred = predict(model, X);

% Tahmin edilen değerlerle gerçek değerler arasındaki karşılaştırma
% Örneğin, ilk 10 tahmini kontrol etmek için:
disp('Gerçek Değerler vs. Tahmin Edilen Değerler:');
disp([Y(1:5), Y_pred(1:5)]);

% Model performansını değerlendirme
% Örneğin, ortalama kare hatayı kontrol etmek için:
disp(['Ortalama Kare Hata: ', num2str(mse)]);

% Scatter Plot (Nokta Grafiği)
figure;
scatter(Y, Y_pred);
xlabel('Gerçek Değerler');
ylabel('Tahmin Edilen Değerler');
title('Gerçek Değerler vs. Tahmin Edilen Değerler');

% Hata Dağılımı Grafiği
figure;
error = Y - Y_pred;
histogram(error, 20); % 20 bölüme sahip bir histogram
xlabel('Hata');
ylabel('Frekans');
title('Hata Dağılımı');

