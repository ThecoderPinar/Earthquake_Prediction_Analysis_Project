% Adım 1: Veriyi yükleme ve hazırlama
data = readtable('Earthquake_Prediction_Analysis_Project/earthquake_data.csv');

% Giriş ve çıkış özelliklerini ayarlama
X = [data.mag, data.depth]; % Deprem büyüklüğü ve derinlik özellikleri
Y = data.mag; % Tahmin edilecek değerler: Deprem büyüklükleri

% Veri setinin özet bilgilerini görüntüleme
disp('Veri Seti Özeti:');
summary(data);

% Veri setindeki eksik değerleri kontrol etme
missing_values = any(ismissing(data));
if any(missing_values)
    disp('Veri Setinde Eksik Değerler Var!');
    disp('Eksik Değerlerin Sayısı:');
    disp(sum(missing_values));
else
    disp('Veri Setinde Eksik Değer Yok');
end

% Giriş ve çıkış özelliklerinin boyutlarını kontrol etme
disp('Giriş Özelliklerinin Boyutu:');
disp(size(X));
disp('Çıkış Özelliklerinin Boyutu:');
disp(size(Y));

% Veri görselleştirme (isteğe bağlı olarak)
figure;
subplot(2, 1, 1);
histogram(Y);
xlabel('Deprem Büyüklüğü');
ylabel('Frekans');
title('Deprem Büyüklüğü Dağılımı');

subplot(2, 1, 2);
scatter3(X(:, 1), X(:, 2), Y);
xlabel('Deprem Büyüklüğü');
ylabel('Derinlik');
zlabel('Deprem Büyüklüğü');
title('Deprem Büyüklüğü ve Derinlik İlişkisi');

% İleri analiz ve modelleme adımlarına devam etme

% Adım 2: Veri ön işleme ve model oluşturma
% Veriyi eğitim ve test setlerine ayırma
rng(1); % Rastgele sayı üreteciyi başlatma
cv = cvpartition(size(X, 1), 'HoldOut', 0.2);
idxTrain = training(cv); % Eğitim seti için indeksler
idxTest = test(cv); % Test seti için indeksler

X_train = X(idxTrain, :); % Eğitim seti giriş özellikleri
Y_train = Y(idxTrain, :); % Eğitim seti çıkış özellikleri
X_test = X(idxTest, :); % Test seti giriş özellikleri
Y_test = Y(idxTest, :); % Test seti çıkış özellikleri

% Model oluşturma
model = fitrsvm(X_train, Y_train, 'KernelFunction', 'gaussian');

% Adım 3: Modelin Değerlendirilmesi
% Eğitim seti üzerinde tahminler yapma
Y_pred_train = predict(model, X_train);

% Eğitim seti performans metriklerini hesaplama
mse_train = mean((Y_train - Y_pred_train).^2); % Ortalama Kare Hata (MSE)

% Test seti üzerinde tahminler yapma
Y_pred_test = predict(model, X_test);

% Test seti performans metriklerini hesaplama
mse_test = mean((Y_test - Y_pred_test).^2); % Ortalama Kare Hata (MSE)

% Sonuçların görselleştirilmesi (isteğe bağlı olarak)
figure;
subplot(1, 2, 1);
plot(Y_train, Y_pred_train, 'bo');
hold on;
plot(Y_train, Y_train, 'r-', 'LineWidth', 2);
hold off;
xlabel('Gerçek Değerler');
ylabel('Tahmin Edilen Değerler');
title('Eğitim Seti Tahminleri');
legend('Tahminler', 'Doğru Eğim');

subplot(1, 2, 2);
plot(Y_test, Y_pred_test, 'bo');
hold on;
plot(Y_test, Y_test, 'r-', 'LineWidth', 2);
hold off;
xlabel('Gerçek Değerler');
ylabel('Tahmin Edilen Değerler');
title('Test Seti Tahminleri');
legend('Tahminler', 'Doğru Eğim');

% Performans metriklerinin görüntülenmesi
disp('Eğitim Seti Ortalama Kare Hata (MSE):');
disp(mse_train);
disp('Test Seti Ortalama Kare Hata (MSE):');
disp(mse_test);

% Modelin optimize edilmesi
rng(1); % Rastgele sayı üreteciyi başlatma
Mdl = fitrsvm(X, Y, 'OptimizeHyperparameters', {'BoxConstraint', 'KernelScale', 'Epsilon'}, ...
              'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName', 'expected-improvement-plus', 'MaxObjectiveEvaluations', 50, 'ShowPlots', true));

% En iyi hiperparametreleri al
bestParams = Mdl.ModelParameters;

% En iyi modeli oluşturma
bestModel = fitrsvm(X, Y, 'BoxConstraint', bestParams.BoxConstraint, 'KernelScale', bestParams.KernelScale, 'Epsilon', bestParams.Epsilon);

% Özellik ölçeklendirme
X_scaled = zscore(X);

% Eksik verilerin doldurulması
X_filled = fillmissing(X, 'linear');

% Aykırı değerlerin ele alınması
X_cleaned = rmoutliers(X);

% Yeni özellikler türetme
X_new = [X, X.^2, log(X+1)];

% Veri setine yeni özellikler ekleme
new_feature = sin(X(:, 1)) + cos(X(:, 2));
X_with_new_feature = [X, new_feature];