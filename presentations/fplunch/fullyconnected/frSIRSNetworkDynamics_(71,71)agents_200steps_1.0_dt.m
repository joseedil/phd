steps = 200;
dt = 1.0;
replications = 0;
dynamics = [
1.000,0.000,0.000;
1.000,0.000,0.000;
1.000,0.000,0.000;
1.000,0.000,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.999,0.001,0.000;
0.998,0.001,0.000;
0.998,0.001,0.001;
0.998,0.001,0.001;
0.998,0.002,0.001;
0.997,0.002,0.001;
0.997,0.002,0.001;
0.997,0.002,0.001;
0.997,0.002,0.001;
0.996,0.002,0.001;
0.996,0.003,0.001;
0.996,0.003,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.994,0.004,0.001;
0.994,0.004,0.001;
0.994,0.005,0.002;
0.994,0.005,0.002;
0.993,0.006,0.002;
0.992,0.006,0.002;
0.992,0.006,0.003;
0.991,0.006,0.003;
0.991,0.006,0.003;
0.991,0.006,0.003;
0.990,0.006,0.004;
0.990,0.007,0.004;
0.989,0.006,0.004;
0.989,0.006,0.005;
0.988,0.007,0.005;
0.987,0.008,0.006;
0.986,0.008,0.006;
0.986,0.008,0.006;
0.985,0.009,0.006;
0.984,0.009,0.007;
0.982,0.010,0.008;
0.982,0.010,0.008;
0.980,0.011,0.009;
0.979,0.012,0.009;
0.978,0.013,0.009;
0.976,0.014,0.010;
0.975,0.015,0.010;
0.974,0.016,0.011;
0.972,0.016,0.011;
0.971,0.017,0.012;
0.969,0.017,0.013;
0.968,0.018,0.014;
0.965,0.020,0.014;
0.963,0.021,0.015;
0.961,0.023,0.016;
0.958,0.024,0.018;
0.956,0.026,0.018;
0.951,0.029,0.020;
0.948,0.031,0.021;
0.944,0.035,0.022;
0.942,0.034,0.024;
0.939,0.036,0.025;
0.935,0.038,0.026;
0.932,0.041,0.028;
0.928,0.043,0.029;
0.923,0.046,0.031;
0.919,0.048,0.032;
0.913,0.052,0.035;
0.910,0.053,0.037;
0.905,0.055,0.039;
0.900,0.059,0.042;
0.895,0.061,0.044;
0.889,0.062,0.049;
0.881,0.068,0.052;
0.875,0.069,0.056;
0.869,0.073,0.058;
0.860,0.079,0.061;
0.853,0.083,0.065;
0.847,0.085,0.068;
0.839,0.089,0.072;
0.830,0.093,0.077;
0.821,0.098,0.081;
0.813,0.101,0.087;
0.803,0.107,0.090;
0.792,0.113,0.095;
0.781,0.119,0.100;
0.770,0.124,0.105;
0.760,0.129,0.111;
0.750,0.131,0.119;
0.735,0.140,0.125;
0.724,0.145,0.131;
0.712,0.147,0.140;
0.699,0.153,0.147;
0.687,0.160,0.153;
0.676,0.163,0.161;
0.665,0.165,0.170;
0.653,0.168,0.179;
0.640,0.172,0.187;
0.626,0.176,0.197;
0.614,0.178,0.208;
0.602,0.179,0.219;
0.590,0.181,0.230;
0.579,0.182,0.240;
0.563,0.186,0.250;
0.549,0.186,0.265;
0.542,0.182,0.276;
0.532,0.180,0.288;
0.521,0.179,0.301;
0.510,0.177,0.313;
0.500,0.175,0.324;
0.489,0.176,0.335;
0.480,0.173,0.347;
0.469,0.171,0.360;
0.460,0.167,0.374;
0.453,0.161,0.386;
0.444,0.158,0.398;
0.434,0.156,0.410;
0.426,0.153,0.421;
0.419,0.144,0.437;
0.414,0.135,0.451;
0.408,0.134,0.458;
0.400,0.133,0.468;
0.393,0.127,0.479;
0.387,0.123,0.490;
0.382,0.118,0.500;
0.375,0.114,0.511;
0.370,0.110,0.520;
0.364,0.105,0.531;
0.360,0.099,0.540;
0.357,0.096,0.547;
0.352,0.092,0.556;
0.348,0.085,0.566;
0.346,0.081,0.574;
0.343,0.076,0.581;
0.339,0.075,0.586;
0.336,0.072,0.592;
0.333,0.066,0.600;
0.330,0.063,0.607;
0.327,0.060,0.613;
0.326,0.056,0.618;
0.324,0.051,0.625;
0.322,0.048,0.630;
0.320,0.045,0.636;
0.318,0.042,0.640;
0.316,0.040,0.643;
0.314,0.038,0.648;
0.313,0.035,0.652;
0.311,0.035,0.654;
0.310,0.034,0.657;
0.309,0.031,0.661;
0.308,0.028,0.664;
0.307,0.026,0.667;
0.307,0.024,0.670;
0.305,0.022,0.673;
0.304,0.022,0.674;
0.303,0.021,0.676;
0.302,0.020,0.678;
0.301,0.018,0.680;
0.301,0.017,0.682;
0.300,0.016,0.684;
0.300,0.014,0.686;
0.299,0.014,0.687;
0.299,0.012,0.689;
0.298,0.011,0.690;
0.298,0.011,0.691;
0.297,0.011,0.692;
0.297,0.010,0.693;
0.297,0.010,0.693;
0.296,0.009,0.695;
0.296,0.008,0.696;
0.296,0.007,0.697;
0.296,0.006,0.698;
0.296,0.006,0.699;
0.296,0.005,0.699;
0.296,0.004,0.700;
0.296,0.004,0.700;
0.296,0.004,0.701;
0.296,0.004,0.701;
0.296,0.003,0.702;
0.295,0.003,0.702;
0.295,0.002,0.703;
0.295,0.002,0.703;
0.295,0.001,0.703;
0.295,0.001,0.704;
0.295,0.001,0.704;
0.295,0.001,0.704;
0.295,0.001,0.704;
0.295,0.001,0.704;
0.295,0.001,0.704;
0.295,0.001,0.704;
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
xlabel ('Steps');
ylabel ('Ratio');
legend('Susceptible','Infected', 'Recovered');
title ('SIRS Dynamics with 1.0 dt, 200 steps, 0 replications');
