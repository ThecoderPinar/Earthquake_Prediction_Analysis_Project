% Veriyi okuma
data = readtable('Earthquake_Prediction_Analysis_Project/earthquake_data.csv');

% Giriş ve çıkış özelliklerini ayarlama
X = [data.mag, data.depth]; % Deprem büyüklüğü ve derinlik özellikleri
Y = data.mag; % Tahmin edilecek değerler: Deprem büyüklükleri

% Gelişmiş veri görselleştirme ve analiz
figure;

% Deprem büyüklüğü dağılımının histogramı
subplot(2, 2, 1);
histogram(Y, 'FaceColor', '#7E2F8E', 'EdgeColor', '#4A245D');
xlabel('Deprem Büyüklüğü');
ylabel('Frekans');
title('Deprem Büyüklüğü Dağılımı');
saveas(gcf, 'figure1.png');

% Deprem derinliği ve büyüklük ilişkisinin 3D gösterimi
subplot(2, 2, 2);
scatter3(X(:, 1), X(:, 2), Y, 50, Y, 'filled');
colormap(jet);
colorbar;
xlabel('Deprem Büyüklüğü');
ylabel('Derinlik (km)');
zlabel('Deprem Büyüklüğü');
title('Deprem Büyüklüğü ve Derinlik İlişkisi');
saveas(gcf, 'figure2.png');

% Özellikler arasındaki ilişkinin heatmap gösterimi
subplot(2, 2, [3, 4]);
corr_matrix = corrcoef([X, Y]);
heatmap({'Deprem Büyüklüğü', 'Derinlik (km)'}, {'Deprem Büyüklüğü', 'Derinlik (km)'}, corr_matrix(1:2, 1:2),...
    'Colormap', jet, 'ColorbarVisible', 'off', 'FontSize', 10, 'CellLabelColor','none');
title('Özellikler Arasındaki Korelasyon');
saveas(gcf, 'figure3.png');

% Model oluşturma
rng(1); % Rastgele sayı üreteciyi başlatma
model = fitrsvm(X, Y, 'KernelFunction', 'gaussian');

% Tahminlerin görselleştirilmesi
Y_pred = predict(model, X);
figure;
plot(Y, Y_pred, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', '#D95319', 'MarkerFaceColor', '#EDB120');
hold on;
plot([min(Y), max(Y)], [min(Y), max(Y)], '-', 'Color', '#77AC30', 'LineWidth', 2);
hold off;
xlabel('Gerçek Değerler');
ylabel('Tahmin Edilen Değerler');
title('Model Tahminleri');
legend('Tahminler', 'Doğru Eğim', 'Location', 'southeast');
saveas(gcf, 'figure4.png');

% Model performansının görselleştirilmesi
residuals = Y - Y_pred;
figure;
subplot(2, 1, 1);
histogram(residuals, 'FaceColor', '#7E2F8E', 'EdgeColor', '#4A245D');
xlabel('Artık (Residual)');
ylabel('Frekans');
title('Model Artıklarının Dağılımı');

subplot(2, 1, 2);
plot(Y, residuals, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', '#D95319', 'MarkerFaceColor', '#EDB120');
xlabel('Gerçek Değerler');
ylabel('Artık (Residual)');
title('Gerçek Değerler ve Artıklar Arasındaki İlişki');
saveas(gcf, 'figure5.png');

% Veri setine yeni özellikler ekleme
new_feature = sin(X(:, 1)) + cos(X(:, 2));
X_with_new_feature = [X, new_feature];

% Scatter plot ile yeni özelliklerin dağılımını gösterme
figure;
scatter3(X_with_new_feature(:, 1), X_with_new_feature(:, 2), new_feature, 50, Y, 'filled');
colormap(jet);
colorbar;
xlabel('Deprem Büyüklüğü');
ylabel('Derinlik (km)');
zlabel('Yeni Özellik');
title('Yeni Özelliklerin Deprem Büyüklüğü ve Derinlik ile İlişkisi');
saveas(gcf, 'figure6.png');

% Pair plot ile özellikler arasındaki ilişkiyi gösterme
figure;
gplotmatrix(X_with_new_feature, [], Y, 'rb', 'o', [], 'on', [], {'Deprem Büyüklüğü', 'Derinlik (km)', 'Yeni Özellik'});
sgtitle('Özellikler Arasındaki İlişki');

% Korelasyon matrisi görselleştirme
corr_matrix = corrcoef([X, Y]);
figure;
heatmap({'Deprem Büyüklüğü', 'Derinlik (km)', 'Yeni Özellik'}, ...
        {'Deprem Büyüklüğü', 'Derinlik (km)', 'Yeni Özellik'}, ...
        corr_matrix(1:3, 1:3), 'Colormap', jet, 'ColorbarVisible', 'off', ...
        'FontSize', 10, 'CellLabelColor', 'none');
title('Özellikler Arasındaki Korelasyon');
saveas(gcf, 'figure7.png');

% PCA (Principal Component Analysis) ile boyut indirgeme ve görselleştirme
coeff = pca(X);
X_pca = X * coeff(:,1:2); % İlk iki bileşeni al
figure;
scatter(X_pca(:,1), X_pca(:,2), 50, Y, 'filled');
colormap(jet);
colorbar;
xlabel('Birinci Bileşen');
ylabel('İkinci Bileşen');
title('PCA ile Boyut İndirgeme');
saveas(gcf, 'figure8.png');

% Gaussian kernel ile yoğunluk tahmini
[f, xi] = ksdensity(X(:,1));
[g, yi] = ksdensity(X(:,2));

% Yoğunluk tahminlerini görselleştirme
figure;
plot(xi, f, 'LineWidth', 2, 'Color', '#0072BD');
hold on;
plot(yi, g, 'LineWidth', 2, 'Color', '#D95319');
xlabel('Değer');
ylabel('Yoğunluk');
title('Gaussian Kernel Density Estimation (KDE)');
legend('Deprem Büyüklüğü', 'Derinlik (km)');
hold off;
saveas(gcf, 'figure9.png');

% Çoklu özelliklerin paralel koordinatlarla görselleştirilmesi
figure;
parallelcoords([X Y], 'Group', [], 'Standardize', 'on', ...
               'Quantile', 0.25, 'LineWidth', 2);
xlabel('Özellikler');
ylabel('Standartlaştırılmış Değerler');
title('Paralel Koordinatlarla Özelliklerin Karşılaştırılması');
saveas(gcf, 'figure10.png');

% Yeni bir tema seçimi
set(groot,'defaultAxesColorOrder',[0 0.447 0.741;0.85 0.325 0.098;0.929 0.694 0.125]);

% Eğitim verisinin özelliklerinin karşılıklı dağılım gösterimi
figure;
gplotmatrix(X, [], Y, 'rb', 'o', [], 'on', 'hist', {'Deprem Büyüklüğü', 'Derinlik (km)'}, {'Deprem Büyüklüğü', 'Derinlik (km)'});
sgtitle('Eğitim Verisi Özelliklerinin Karşılıklı Dağılımı');
saveas(gcf, 'figure11.png');

% Eğitim verisindeki artıkların dağılımı
figure;
histogram(residuals, 'FaceColor', '#77AC30', 'EdgeColor', '#4A245D');
xlabel('Artık (Residual)');
ylabel('Frekans');
title('Model Artıklarının Dağılımı');
saveas(gcf, 'figure12.png');

% Eğitim verisindeki artıkların zaman serisi gösterimi
figure;
plot(residuals, 'LineWidth', 2, 'Color', '#D95319');
xlabel('Örnekler');
ylabel('Artık (Residual)');
title('Model Artıklarının Zaman Serisi');
saveas(gcf, 'figure13.png');

% Model tahminlerinin ve gerçek değerlerin zaman serisi gösterimi
figure;
plot(Y, '-o', 'MarkerSize', 6, 'MarkerEdgeColor', '#EDB120', 'MarkerFaceColor', '#EDB120');
hold on;
plot(Y_pred, '-o', 'MarkerSize', 6, 'MarkerEdgeColor', '#77AC30', 'MarkerFaceColor', '#77AC30');
xlabel('Örnekler');
ylabel('Değer');
title('Model Tahminleri ve Gerçek Değerlerin Zaman Serisi');
legend('Gerçek Değerler', 'Tahminler');
saveas(gcf, 'figure15.png');

% Eğitim verisinin özelliklerinin kutu grafiği
figure;
boxplot(X, 'Labels', {'Deprem Büyüklüğü', 'Derinlik (km)'});
title('Eğitim Verisi Özelliklerinin Kutu Grafiği');
saveas(gcf, 'figure16.png');

% Artıkların yoğunluk tahmini grafiği
figure;
[f, xi] = ksdensity(residuals);
plot(xi, f, 'LineWidth', 2, 'Color', '#0072BD');
xlabel('Artık (Residual)');
ylabel('Yoğunluk');
title('Artık Değerlerinin Yoğunluk Tahmini');
saveas(gcf, 'figure17.png');

% Modelin özellik önem derecelerinin gösterimi
figure;
bar(model.Beta, 'FaceColor', '#77AC30', 'EdgeColor', '#4A245D');
xlabel('Özellikler');
ylabel('Önem Dereceleri');
title('Modelin Özellik Önem Dereceleri');
saveas(gcf, 'figure18.png');

% Belirli bir hiperparametre için performansın görselleştirilmesi
param_values = [0.01, 0.1, 1, 10, 100]; % BoxConstraint değerleri
mse_values = zeros(size(param_values)); % Ortalama kare hata değerleri

for i = 1:numel(param_values)
    % Modeli oluşturma
    model = fitrsvm(X_train, Y_train, 'KernelFunction', 'gaussian', 'BoxConstraint', param_values(i));
    
    % Test seti üzerinde tahminler yapma
    Y_pred_test = predict(model, X_test);
    
    % Ortalama kare hata hesaplama
    mse_values(i) = mean((Y_test - Y_pred_test).^2);
end

% Çizgi grafiği ile performansın görselleştirilmesi
figure;
plot(param_values, mse_values, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerEdgeColor', '#D95319', 'MarkerFaceColor', '#EDB120');
xlabel('BoxConstraint Değeri');
ylabel('Ortalama Kare Hata (MSE)');
title('BoxConstraint Değerine Göre Model Performansı');
saveas(gcf, 'figure19.png');

% Özellikler arası ilişkinin 3D gösterimi
figure;
scatter3(X(:, 1), X(:, 2), Y, 50, Y, 'filled');
colormap(jet);
colorbar;
xlabel('Deprem Büyüklüğü');
ylabel('Derinlik (km)');
zlabel('Deprem Büyüklüğü');
title('Özellikler Arası İlişkinin 3D Gösterimi');
saveas(gcf, 'figure20.png');

% Artık ve özellikler arasındaki korelasyon haritası
figure;
corr_matrix = corrcoef([X, residuals]);
heatmap({'Deprem Büyüklüğü', 'Derinlik (km)', 'Artık'}, {'Deprem Büyüklüğü', 'Derinlik (km)', 'Artık'}, corr_matrix, ...
    'Colormap', jet, 'ColorbarVisible', 'off', 'FontSize', 10, 'CellLabelColor', 'none');
title('Özellikler ve Artık Arasındaki Korelasyon');
saveas(gcf, 'figure21.png');
