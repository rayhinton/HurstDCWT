% gen and save 2d FBM
rng(2)

side_length = 512;
H = 0.75;

fbm_data = MakeFBM2D([side_length side_length], H);

%%
writematrix(fbm_data, "fbm2d_" + side_length + "_" + H + ".csv");