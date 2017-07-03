steps = 250;
dt = 1.0;
replications = 0;
dynamics = [
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.997,0.003,0.000;
0.996,0.004,0.000;
0.996,0.004,0.000;
0.995,0.005,0.000;
0.994,0.006,0.000;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.992,0.007,0.001;
0.992,0.006,0.002;
0.991,0.007,0.002;
0.991,0.007,0.002;
0.991,0.007,0.002;
0.991,0.007,0.002;
0.990,0.007,0.003;
0.990,0.006,0.004;
0.989,0.007,0.004;
0.988,0.007,0.005;
0.988,0.006,0.006;
0.986,0.006,0.007;
0.985,0.007,0.007;
0.983,0.009,0.007;
0.982,0.010,0.007;
0.982,0.009,0.008;
0.981,0.010,0.008;
0.980,0.010,0.009;
0.978,0.012,0.009;
0.976,0.015,0.009;
0.976,0.015,0.009;
0.974,0.016,0.010;
0.973,0.017,0.010;
0.972,0.017,0.011;
0.970,0.018,0.012;
0.969,0.019,0.012;
0.967,0.020,0.014;
0.965,0.021,0.015;
0.961,0.022,0.017;
0.961,0.021,0.018;
0.959,0.023,0.018;
0.957,0.024,0.019;
0.956,0.024,0.020;
0.953,0.025,0.022;
0.952,0.024,0.024;
0.949,0.027,0.024;
0.947,0.027,0.026;
0.945,0.028,0.027;
0.942,0.030,0.028;
0.940,0.030,0.030;
0.937,0.032,0.031;
0.934,0.032,0.033;
0.927,0.037,0.035;
0.922,0.040,0.039;
0.919,0.043,0.039;
0.915,0.045,0.041;
0.907,0.050,0.043;
0.903,0.053,0.044;
0.899,0.054,0.047;
0.898,0.054,0.048;
0.890,0.059,0.051;
0.884,0.062,0.053;
0.879,0.066,0.055;
0.876,0.066,0.058;
0.869,0.071,0.060;
0.861,0.076,0.063;
0.853,0.081,0.066;
0.842,0.085,0.073;
0.832,0.089,0.078;
0.826,0.093,0.081;
0.817,0.098,0.085;
0.801,0.106,0.093;
0.791,0.112,0.097;
0.781,0.118,0.101;
0.770,0.128,0.102;
0.757,0.133,0.110;
0.750,0.134,0.116;
0.738,0.142,0.121;
0.730,0.146,0.124;
0.720,0.149,0.131;
0.707,0.154,0.139;
0.697,0.156,0.147;
0.685,0.157,0.158;
0.670,0.162,0.168;
0.659,0.168,0.174;
0.645,0.172,0.183;
0.630,0.172,0.199;
0.619,0.172,0.209;
0.607,0.175,0.219;
0.593,0.177,0.230;
0.579,0.178,0.243;
0.573,0.177,0.250;
0.559,0.179,0.262;
0.546,0.184,0.270;
0.534,0.186,0.280;
0.522,0.184,0.293;
0.511,0.186,0.303;
0.506,0.179,0.315;
0.502,0.169,0.330;
0.486,0.173,0.341;
0.477,0.169,0.355;
0.467,0.162,0.370;
0.460,0.159,0.381;
0.450,0.157,0.393;
0.443,0.150,0.407;
0.435,0.144,0.421;
0.428,0.146,0.427;
0.421,0.137,0.441;
0.415,0.131,0.454;
0.413,0.121,0.466;
0.407,0.116,0.478;
0.396,0.114,0.489;
0.392,0.113,0.494;
0.386,0.116,0.498;
0.382,0.104,0.514;
0.380,0.097,0.523;
0.376,0.092,0.533;
0.371,0.088,0.540;
0.368,0.081,0.550;
0.364,0.079,0.557;
0.357,0.078,0.565;
0.356,0.072,0.572;
0.352,0.070,0.579;
0.349,0.067,0.585;
0.347,0.067,0.587;
0.343,0.063,0.593;
0.341,0.055,0.604;
0.339,0.053,0.608;
0.336,0.050,0.614;
0.335,0.047,0.618;
0.334,0.046,0.620;
0.330,0.046,0.624;
0.330,0.042,0.629;
0.326,0.043,0.632;
0.322,0.043,0.636;
0.322,0.035,0.643;
0.320,0.035,0.644;
0.320,0.031,0.648;
0.318,0.030,0.651;
0.317,0.029,0.653;
0.317,0.026,0.657;
0.316,0.025,0.659;
0.315,0.024,0.661;
0.315,0.021,0.664;
0.315,0.020,0.665;
0.315,0.019,0.666;
0.315,0.015,0.670;
0.314,0.016,0.670;
0.314,0.011,0.674;
0.312,0.009,0.678;
0.312,0.009,0.678;
0.311,0.009,0.680;
0.311,0.009,0.680;
0.311,0.007,0.682;
0.311,0.006,0.683;
0.311,0.006,0.683;
0.311,0.005,0.684;
0.311,0.004,0.685;
0.310,0.005,0.685;
0.310,0.005,0.685;
0.310,0.005,0.685;
0.310,0.005,0.685;
0.310,0.004,0.686;
0.310,0.004,0.686;
0.309,0.003,0.688;
0.308,0.004,0.688;
0.308,0.003,0.689;
0.308,0.003,0.689;
0.308,0.003,0.689;
0.308,0.003,0.689;
0.308,0.003,0.689;
0.308,0.003,0.689;
0.308,0.003,0.689;
0.308,0.002,0.690;
0.308,0.002,0.690;
0.308,0.002,0.690;
0.308,0.002,0.690;
0.308,0.002,0.690;
0.308,0.002,0.690;
0.308,0.001,0.691;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
0.308,0.000,0.692;
];
susceptibleRatio = dynamics (:, 1);
infectedRatio = dynamics (:, 2);
recoveredRatio = dynamics (:, 3);
figure
plot (susceptibleRatio.', 'color', 'green');
hold on
plot (infectedRatio.', 'color', 'red');
hold on
plot (recoveredRatio.', 'color', 'blue');
xlabel ('Time');
ylabel ('Ratio');
legend('Susceptible','Infected', 'Recovered');
title ('SIR Dynamics with 1.0 dt, 250 steps, 961 Agents');
