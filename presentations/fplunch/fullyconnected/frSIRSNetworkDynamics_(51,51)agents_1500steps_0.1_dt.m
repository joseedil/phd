steps = 1500;
dt = 0.1;
replications = 0;
dynamics = [
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
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.998,0.002,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.997,0.003,0.000;
0.996,0.004,0.000;
0.996,0.004,0.000;
0.996,0.004,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.005,0.000;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.995,0.005,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.995,0.004,0.001;
0.994,0.005,0.001;
0.994,0.005,0.001;
0.994,0.005,0.001;
0.994,0.005,0.001;
0.994,0.005,0.001;
0.993,0.005,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.993,0.006,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.001;
0.992,0.007,0.002;
0.992,0.007,0.002;
0.992,0.007,0.002;
0.992,0.007,0.002;
0.992,0.007,0.002;
0.992,0.007,0.002;
0.992,0.007,0.002;
0.991,0.007,0.002;
0.991,0.007,0.002;
0.991,0.008,0.002;
0.991,0.008,0.002;
0.991,0.008,0.002;
0.991,0.008,0.002;
0.991,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.008,0.002;
0.990,0.009,0.002;
0.990,0.009,0.002;
0.990,0.009,0.002;
0.990,0.009,0.002;
0.990,0.009,0.002;
0.990,0.009,0.002;
0.990,0.009,0.002;
0.989,0.009,0.002;
0.989,0.010,0.002;
0.989,0.010,0.002;
0.989,0.009,0.002;
0.989,0.009,0.002;
0.989,0.009,0.002;
0.988,0.010,0.002;
0.988,0.010,0.002;
0.988,0.010,0.002;
0.988,0.010,0.002;
0.988,0.010,0.002;
0.988,0.010,0.002;
0.987,0.011,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.010,0.002;
0.987,0.011,0.002;
0.987,0.011,0.002;
0.987,0.011,0.002;
0.987,0.011,0.002;
0.987,0.011,0.002;
0.986,0.012,0.002;
0.986,0.012,0.002;
0.985,0.012,0.002;
0.985,0.012,0.002;
0.985,0.012,0.002;
0.985,0.013,0.002;
0.984,0.013,0.002;
0.984,0.013,0.002;
0.984,0.013,0.002;
0.984,0.013,0.002;
0.984,0.014,0.002;
0.984,0.014,0.002;
0.983,0.015,0.002;
0.983,0.015,0.002;
0.983,0.015,0.002;
0.983,0.015,0.002;
0.983,0.015,0.002;
0.982,0.015,0.002;
0.982,0.016,0.002;
0.982,0.016,0.002;
0.982,0.016,0.002;
0.981,0.017,0.002;
0.981,0.017,0.002;
0.981,0.017,0.002;
0.980,0.017,0.002;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.980,0.017,0.003;
0.979,0.018,0.003;
0.979,0.017,0.003;
0.979,0.017,0.003;
0.979,0.018,0.003;
0.979,0.018,0.003;
0.979,0.018,0.003;
0.979,0.018,0.003;
0.978,0.019,0.003;
0.977,0.019,0.004;
0.977,0.018,0.004;
0.977,0.018,0.004;
0.977,0.018,0.005;
0.977,0.018,0.005;
0.977,0.018,0.005;
0.977,0.018,0.005;
0.977,0.018,0.005;
0.977,0.018,0.005;
0.975,0.020,0.005;
0.975,0.020,0.005;
0.975,0.020,0.005;
0.975,0.020,0.005;
0.974,0.021,0.005;
0.974,0.021,0.005;
0.974,0.021,0.005;
0.973,0.022,0.005;
0.973,0.022,0.005;
0.973,0.022,0.005;
0.973,0.022,0.005;
0.972,0.023,0.005;
0.971,0.023,0.006;
0.971,0.023,0.006;
0.971,0.023,0.006;
0.970,0.024,0.006;
0.969,0.025,0.006;
0.969,0.024,0.007;
0.969,0.024,0.007;
0.969,0.024,0.007;
0.969,0.024,0.007;
0.969,0.024,0.007;
0.968,0.025,0.007;
0.968,0.025,0.007;
0.967,0.025,0.007;
0.967,0.026,0.007;
0.967,0.025,0.008;
0.967,0.025,0.008;
0.967,0.025,0.008;
0.966,0.026,0.008;
0.966,0.026,0.008;
0.966,0.026,0.008;
0.965,0.026,0.008;
0.965,0.026,0.008;
0.965,0.027,0.008;
0.965,0.027,0.008;
0.965,0.027,0.008;
0.965,0.027,0.008;
0.965,0.027,0.008;
0.964,0.027,0.008;
0.964,0.027,0.008;
0.964,0.027,0.008;
0.964,0.027,0.008;
0.963,0.028,0.008;
0.963,0.028,0.008;
0.963,0.029,0.008;
0.962,0.029,0.009;
0.962,0.029,0.009;
0.962,0.028,0.009;
0.962,0.029,0.009;
0.961,0.030,0.009;
0.961,0.030,0.009;
0.961,0.030,0.009;
0.960,0.030,0.010;
0.959,0.031,0.010;
0.959,0.031,0.010;
0.959,0.031,0.010;
0.958,0.032,0.010;
0.958,0.032,0.010;
0.958,0.032,0.010;
0.957,0.033,0.010;
0.957,0.033,0.010;
0.957,0.033,0.010;
0.957,0.033,0.010;
0.956,0.034,0.010;
0.956,0.034,0.010;
0.955,0.034,0.010;
0.955,0.035,0.010;
0.954,0.035,0.011;
0.954,0.035,0.011;
0.954,0.035,0.011;
0.953,0.036,0.011;
0.953,0.036,0.011;
0.952,0.037,0.011;
0.952,0.036,0.012;
0.952,0.036,0.012;
0.952,0.037,0.012;
0.951,0.037,0.012;
0.951,0.037,0.012;
0.950,0.037,0.012;
0.950,0.037,0.013;
0.950,0.038,0.013;
0.949,0.038,0.013;
0.949,0.038,0.013;
0.948,0.039,0.013;
0.948,0.039,0.013;
0.948,0.040,0.013;
0.947,0.040,0.013;
0.947,0.041,0.013;
0.945,0.042,0.013;
0.945,0.042,0.013;
0.944,0.043,0.013;
0.944,0.043,0.013;
0.944,0.043,0.013;
0.942,0.045,0.013;
0.942,0.046,0.013;
0.942,0.045,0.013;
0.942,0.045,0.013;
0.942,0.045,0.013;
0.941,0.045,0.013;
0.941,0.045,0.013;
0.941,0.045,0.014;
0.941,0.045,0.014;
0.940,0.045,0.015;
0.940,0.045,0.015;
0.938,0.047,0.015;
0.937,0.048,0.015;
0.935,0.049,0.016;
0.933,0.051,0.016;
0.933,0.051,0.016;
0.932,0.052,0.016;
0.931,0.053,0.016;
0.930,0.053,0.016;
0.929,0.054,0.017;
0.928,0.055,0.017;
0.927,0.056,0.017;
0.926,0.057,0.017;
0.925,0.057,0.017;
0.925,0.058,0.018;
0.924,0.058,0.018;
0.924,0.058,0.018;
0.924,0.058,0.018;
0.922,0.059,0.019;
0.921,0.060,0.019;
0.921,0.060,0.019;
0.921,0.060,0.020;
0.920,0.060,0.020;
0.919,0.061,0.020;
0.917,0.063,0.020;
0.916,0.064,0.020;
0.915,0.064,0.020;
0.915,0.065,0.020;
0.913,0.066,0.020;
0.913,0.067,0.020;
0.912,0.067,0.021;
0.911,0.068,0.021;
0.910,0.069,0.021;
0.909,0.070,0.021;
0.909,0.070,0.021;
0.908,0.071,0.021;
0.908,0.071,0.021;
0.907,0.071,0.022;
0.906,0.071,0.023;
0.905,0.072,0.023;
0.903,0.074,0.023;
0.903,0.075,0.023;
0.900,0.077,0.023;
0.900,0.077,0.023;
0.899,0.078,0.023;
0.899,0.078,0.023;
0.898,0.079,0.023;
0.898,0.078,0.025;
0.896,0.079,0.025;
0.895,0.080,0.025;
0.895,0.080,0.025;
0.895,0.079,0.026;
0.894,0.080,0.026;
0.892,0.082,0.026;
0.890,0.082,0.027;
0.889,0.083,0.027;
0.889,0.083,0.027;
0.889,0.083,0.027;
0.888,0.084,0.028;
0.886,0.085,0.029;
0.885,0.086,0.029;
0.884,0.087,0.029;
0.884,0.087,0.030;
0.882,0.087,0.031;
0.880,0.089,0.031;
0.879,0.090,0.031;
0.879,0.090,0.031;
0.878,0.091,0.031;
0.878,0.091,0.031;
0.877,0.092,0.032;
0.876,0.092,0.032;
0.875,0.092,0.033;
0.874,0.093,0.033;
0.873,0.094,0.033;
0.872,0.095,0.033;
0.871,0.096,0.033;
0.870,0.096,0.034;
0.869,0.098,0.034;
0.867,0.098,0.034;
0.866,0.100,0.035;
0.866,0.100,0.035;
0.864,0.101,0.035;
0.863,0.102,0.035;
0.862,0.103,0.035;
0.860,0.104,0.035;
0.859,0.105,0.035;
0.859,0.105,0.036;
0.858,0.106,0.036;
0.857,0.108,0.036;
0.856,0.108,0.036;
0.855,0.108,0.037;
0.854,0.110,0.037;
0.851,0.112,0.037;
0.850,0.113,0.038;
0.849,0.113,0.038;
0.847,0.115,0.038;
0.845,0.116,0.038;
0.845,0.116,0.039;
0.844,0.117,0.039;
0.843,0.118,0.039;
0.841,0.119,0.040;
0.838,0.121,0.041;
0.835,0.123,0.041;
0.834,0.125,0.041;
0.833,0.126,0.042;
0.831,0.127,0.042;
0.830,0.128,0.042;
0.828,0.130,0.043;
0.827,0.130,0.043;
0.824,0.133,0.043;
0.823,0.134,0.043;
0.820,0.136,0.044;
0.819,0.137,0.044;
0.816,0.139,0.045;
0.814,0.141,0.045;
0.813,0.141,0.046;
0.811,0.143,0.046;
0.808,0.146,0.046;
0.807,0.146,0.047;
0.803,0.150,0.047;
0.800,0.152,0.048;
0.799,0.154,0.048;
0.798,0.154,0.048;
0.797,0.155,0.048;
0.795,0.156,0.049;
0.794,0.156,0.049;
0.794,0.156,0.050;
0.793,0.158,0.050;
0.791,0.158,0.050;
0.789,0.160,0.051;
0.788,0.161,0.051;
0.785,0.163,0.052;
0.784,0.165,0.052;
0.782,0.165,0.052;
0.781,0.166,0.053;
0.777,0.169,0.053;
0.776,0.169,0.055;
0.775,0.170,0.055;
0.774,0.171,0.056;
0.772,0.172,0.056;
0.770,0.173,0.056;
0.769,0.173,0.058;
0.765,0.177,0.058;
0.763,0.178,0.058;
0.763,0.179,0.058;
0.761,0.181,0.058;
0.759,0.182,0.059;
0.759,0.183,0.059;
0.757,0.184,0.059;
0.755,0.186,0.059;
0.754,0.186,0.060;
0.752,0.188,0.060;
0.751,0.187,0.062;
0.750,0.187,0.063;
0.747,0.188,0.065;
0.746,0.188,0.067;
0.744,0.189,0.067;
0.742,0.190,0.068;
0.740,0.191,0.069;
0.740,0.190,0.070;
0.735,0.193,0.071;
0.733,0.195,0.072;
0.730,0.197,0.073;
0.728,0.198,0.074;
0.726,0.200,0.075;
0.725,0.200,0.075;
0.724,0.201,0.076;
0.720,0.204,0.076;
0.718,0.206,0.076;
0.715,0.207,0.078;
0.713,0.208,0.079;
0.711,0.210,0.079;
0.709,0.211,0.079;
0.708,0.212,0.080;
0.705,0.214,0.081;
0.702,0.215,0.083;
0.702,0.214,0.084;
0.700,0.215,0.085;
0.699,0.216,0.085;
0.697,0.216,0.087;
0.694,0.219,0.087;
0.691,0.221,0.088;
0.689,0.222,0.089;
0.687,0.223,0.090;
0.685,0.224,0.091;
0.683,0.226,0.091;
0.681,0.227,0.092;
0.679,0.228,0.092;
0.678,0.229,0.093;
0.676,0.231,0.094;
0.674,0.231,0.095;
0.672,0.231,0.097;
0.670,0.233,0.097;
0.668,0.233,0.100;
0.666,0.234,0.100;
0.664,0.235,0.101;
0.661,0.237,0.101;
0.660,0.238,0.102;
0.659,0.239,0.102;
0.657,0.238,0.104;
0.654,0.241,0.105;
0.652,0.243,0.105;
0.650,0.245,0.105;
0.647,0.246,0.106;
0.646,0.246,0.108;
0.644,0.246,0.110;
0.641,0.248,0.111;
0.639,0.250,0.111;
0.636,0.253,0.111;
0.635,0.253,0.112;
0.632,0.254,0.114;
0.629,0.256,0.115;
0.627,0.258,0.116;
0.623,0.260,0.116;
0.621,0.261,0.118;
0.619,0.261,0.120;
0.615,0.264,0.121;
0.612,0.267,0.121;
0.609,0.270,0.122;
0.605,0.273,0.122;
0.603,0.273,0.123;
0.599,0.276,0.124;
0.597,0.278,0.125;
0.595,0.279,0.126;
0.592,0.280,0.127;
0.591,0.281,0.128;
0.586,0.285,0.129;
0.584,0.286,0.130;
0.582,0.286,0.131;
0.580,0.287,0.133;
0.578,0.288,0.134;
0.576,0.290,0.134;
0.572,0.292,0.136;
0.570,0.293,0.137;
0.569,0.293,0.138;
0.566,0.294,0.140;
0.564,0.295,0.141;
0.561,0.298,0.141;
0.561,0.297,0.142;
0.559,0.298,0.143;
0.557,0.300,0.144;
0.556,0.299,0.145;
0.554,0.300,0.146;
0.551,0.300,0.149;
0.550,0.300,0.150;
0.549,0.300,0.151;
0.547,0.300,0.153;
0.546,0.300,0.155;
0.544,0.301,0.155;
0.540,0.304,0.156;
0.537,0.306,0.157;
0.535,0.306,0.159;
0.532,0.306,0.162;
0.529,0.307,0.165;
0.528,0.306,0.166;
0.526,0.307,0.167;
0.523,0.308,0.169;
0.521,0.309,0.170;
0.520,0.308,0.172;
0.516,0.311,0.173;
0.516,0.309,0.176;
0.515,0.308,0.177;
0.514,0.306,0.180;
0.512,0.307,0.181;
0.510,0.306,0.184;
0.508,0.306,0.186;
0.507,0.306,0.187;
0.506,0.306,0.189;
0.503,0.304,0.192;
0.500,0.307,0.193;
0.498,0.306,0.197;
0.497,0.303,0.200;
0.495,0.303,0.201;
0.493,0.304,0.202;
0.491,0.305,0.203;
0.491,0.304,0.205;
0.488,0.306,0.206;
0.487,0.307,0.206;
0.485,0.308,0.207;
0.483,0.308,0.209;
0.481,0.308,0.211;
0.479,0.309,0.212;
0.477,0.308,0.215;
0.475,0.308,0.216;
0.475,0.308,0.218;
0.473,0.308,0.219;
0.471,0.307,0.223;
0.469,0.308,0.224;
0.467,0.308,0.225;
0.465,0.308,0.226;
0.463,0.309,0.228;
0.463,0.308,0.230;
0.462,0.308,0.231;
0.460,0.304,0.235;
0.460,0.303,0.237;
0.456,0.307,0.237;
0.454,0.306,0.239;
0.453,0.306,0.241;
0.453,0.306,0.241;
0.452,0.305,0.243;
0.449,0.306,0.245;
0.448,0.306,0.246;
0.444,0.308,0.248;
0.442,0.309,0.249;
0.438,0.312,0.250;
0.437,0.310,0.253;
0.434,0.311,0.254;
0.433,0.311,0.256;
0.433,0.309,0.258;
0.429,0.311,0.260;
0.426,0.314,0.260;
0.424,0.312,0.265;
0.423,0.310,0.267;
0.421,0.309,0.270;
0.419,0.309,0.272;
0.418,0.308,0.274;
0.416,0.309,0.275;
0.414,0.310,0.276;
0.412,0.308,0.280;
0.410,0.308,0.282;
0.409,0.306,0.285;
0.408,0.305,0.287;
0.407,0.304,0.289;
0.403,0.306,0.291;
0.401,0.306,0.292;
0.400,0.306,0.295;
0.399,0.303,0.298;
0.398,0.304,0.298;
0.396,0.304,0.300;
0.395,0.304,0.301;
0.394,0.303,0.303;
0.392,0.302,0.306;
0.390,0.301,0.309;
0.389,0.300,0.311;
0.389,0.298,0.313;
0.388,0.297,0.315;
0.386,0.297,0.317;
0.384,0.297,0.319;
0.384,0.295,0.321;
0.383,0.295,0.322;
0.381,0.295,0.324;
0.378,0.296,0.326;
0.375,0.298,0.328;
0.374,0.296,0.330;
0.371,0.297,0.332;
0.370,0.296,0.334;
0.369,0.295,0.336;
0.368,0.293,0.339;
0.368,0.292,0.340;
0.366,0.292,0.341;
0.363,0.294,0.343;
0.363,0.291,0.346;
0.361,0.291,0.348;
0.359,0.291,0.350;
0.358,0.289,0.353;
0.357,0.289,0.354;
0.354,0.290,0.356;
0.354,0.288,0.359;
0.353,0.286,0.361;
0.353,0.284,0.364;
0.352,0.283,0.365;
0.350,0.282,0.368;
0.348,0.281,0.371;
0.348,0.279,0.373;
0.346,0.277,0.377;
0.345,0.276,0.379;
0.343,0.276,0.381;
0.342,0.273,0.385;
0.341,0.271,0.388;
0.340,0.269,0.391;
0.339,0.266,0.395;
0.338,0.265,0.397;
0.338,0.261,0.401;
0.336,0.261,0.403;
0.334,0.261,0.405;
0.334,0.259,0.408;
0.331,0.259,0.409;
0.331,0.256,0.414;
0.330,0.254,0.416;
0.329,0.253,0.418;
0.329,0.251,0.420;
0.328,0.250,0.422;
0.327,0.249,0.424;
0.325,0.247,0.428;
0.324,0.246,0.430;
0.323,0.246,0.431;
0.323,0.244,0.434;
0.322,0.243,0.436;
0.321,0.240,0.439;
0.320,0.241,0.439;
0.319,0.240,0.441;
0.319,0.238,0.443;
0.318,0.237,0.444;
0.317,0.236,0.446;
0.317,0.235,0.449;
0.316,0.233,0.450;
0.316,0.233,0.451;
0.315,0.232,0.453;
0.315,0.231,0.454;
0.314,0.230,0.456;
0.312,0.228,0.460;
0.311,0.226,0.463;
0.310,0.225,0.465;
0.309,0.223,0.468;
0.308,0.221,0.471;
0.308,0.220,0.472;
0.308,0.218,0.474;
0.307,0.216,0.477;
0.306,0.215,0.479;
0.304,0.215,0.480;
0.304,0.212,0.484;
0.303,0.212,0.484;
0.303,0.212,0.485;
0.302,0.211,0.486;
0.301,0.211,0.488;
0.300,0.210,0.490;
0.298,0.210,0.492;
0.296,0.210,0.493;
0.296,0.210,0.494;
0.295,0.208,0.497;
0.295,0.205,0.500;
0.294,0.204,0.502;
0.293,0.204,0.503;
0.293,0.203,0.505;
0.291,0.202,0.507;
0.291,0.201,0.509;
0.290,0.200,0.509;
0.289,0.199,0.512;
0.289,0.198,0.513;
0.289,0.196,0.515;
0.287,0.196,0.517;
0.286,0.195,0.519;
0.286,0.193,0.521;
0.285,0.191,0.523;
0.285,0.190,0.525;
0.285,0.190,0.525;
0.284,0.189,0.527;
0.283,0.188,0.529;
0.282,0.186,0.531;
0.281,0.186,0.533;
0.280,0.185,0.535;
0.280,0.184,0.537;
0.278,0.185,0.537;
0.277,0.185,0.538;
0.275,0.185,0.540;
0.275,0.185,0.540;
0.275,0.181,0.544;
0.275,0.180,0.546;
0.274,0.179,0.547;
0.273,0.179,0.547;
0.271,0.180,0.548;
0.271,0.178,0.551;
0.270,0.178,0.552;
0.270,0.175,0.556;
0.270,0.172,0.558;
0.270,0.169,0.562;
0.269,0.168,0.563;
0.268,0.167,0.566;
0.268,0.165,0.567;
0.266,0.166,0.567;
0.266,0.163,0.571;
0.265,0.161,0.574;
0.265,0.159,0.576;
0.265,0.158,0.577;
0.265,0.156,0.579;
0.264,0.155,0.581;
0.263,0.154,0.582;
0.263,0.152,0.584;
0.263,0.151,0.586;
0.262,0.150,0.588;
0.261,0.149,0.590;
0.261,0.148,0.591;
0.261,0.147,0.592;
0.260,0.146,0.593;
0.260,0.144,0.597;
0.259,0.142,0.599;
0.258,0.142,0.600;
0.258,0.141,0.601;
0.258,0.140,0.602;
0.257,0.139,0.604;
0.256,0.138,0.605;
0.256,0.137,0.606;
0.256,0.136,0.608;
0.256,0.134,0.610;
0.256,0.133,0.611;
0.255,0.134,0.611;
0.255,0.133,0.612;
0.255,0.132,0.614;
0.253,0.131,0.616;
0.252,0.132,0.616;
0.252,0.130,0.617;
0.251,0.130,0.619;
0.251,0.126,0.622;
0.251,0.124,0.625;
0.251,0.123,0.626;
0.250,0.120,0.629;
0.250,0.120,0.630;
0.250,0.120,0.631;
0.249,0.120,0.632;
0.249,0.119,0.632;
0.249,0.118,0.634;
0.248,0.115,0.637;
0.248,0.115,0.637;
0.248,0.113,0.639;
0.248,0.111,0.641;
0.247,0.111,0.642;
0.247,0.110,0.643;
0.247,0.108,0.646;
0.245,0.108,0.646;
0.245,0.108,0.647;
0.244,0.108,0.647;
0.244,0.108,0.648;
0.244,0.106,0.650;
0.244,0.104,0.652;
0.244,0.104,0.652;
0.243,0.103,0.654;
0.243,0.101,0.655;
0.243,0.100,0.657;
0.243,0.098,0.658;
0.243,0.098,0.659;
0.241,0.099,0.660;
0.241,0.098,0.661;
0.241,0.098,0.662;
0.241,0.097,0.662;
0.241,0.095,0.664;
0.240,0.095,0.666;
0.240,0.094,0.666;
0.240,0.092,0.669;
0.240,0.091,0.669;
0.239,0.091,0.670;
0.239,0.091,0.671;
0.239,0.090,0.671;
0.238,0.090,0.672;
0.238,0.089,0.673;
0.238,0.087,0.675;
0.238,0.086,0.676;
0.237,0.086,0.677;
0.237,0.085,0.677;
0.237,0.085,0.678;
0.237,0.084,0.679;
0.236,0.083,0.680;
0.236,0.083,0.681;
0.236,0.082,0.681;
0.236,0.083,0.682;
0.236,0.082,0.683;
0.235,0.082,0.683;
0.235,0.081,0.684;
0.234,0.082,0.684;
0.234,0.081,0.685;
0.234,0.081,0.685;
0.234,0.080,0.686;
0.234,0.078,0.688;
0.234,0.077,0.689;
0.234,0.077,0.690;
0.234,0.076,0.691;
0.234,0.074,0.692;
0.234,0.074,0.692;
0.234,0.074,0.692;
0.233,0.074,0.693;
0.232,0.074,0.694;
0.232,0.072,0.696;
0.232,0.072,0.696;
0.232,0.071,0.697;
0.232,0.071,0.697;
0.232,0.070,0.698;
0.232,0.069,0.699;
0.232,0.067,0.700;
0.232,0.066,0.702;
0.231,0.065,0.704;
0.231,0.065,0.704;
0.231,0.064,0.705;
0.231,0.063,0.705;
0.231,0.063,0.706;
0.231,0.062,0.707;
0.230,0.062,0.707;
0.230,0.062,0.709;
0.230,0.061,0.709;
0.229,0.061,0.710;
0.229,0.060,0.711;
0.229,0.060,0.711;
0.228,0.061,0.711;
0.228,0.059,0.713;
0.228,0.058,0.714;
0.228,0.058,0.714;
0.227,0.058,0.715;
0.227,0.058,0.715;
0.227,0.058,0.715;
0.227,0.057,0.716;
0.227,0.056,0.717;
0.226,0.056,0.718;
0.226,0.055,0.719;
0.226,0.055,0.720;
0.226,0.054,0.720;
0.226,0.052,0.722;
0.225,0.052,0.723;
0.225,0.050,0.725;
0.225,0.050,0.725;
0.225,0.050,0.725;
0.225,0.050,0.725;
0.225,0.050,0.726;
0.225,0.049,0.727;
0.225,0.047,0.729;
0.225,0.047,0.729;
0.225,0.046,0.730;
0.225,0.045,0.730;
0.225,0.045,0.730;
0.224,0.046,0.730;
0.224,0.045,0.731;
0.224,0.044,0.732;
0.224,0.044,0.732;
0.224,0.043,0.734;
0.224,0.042,0.734;
0.224,0.042,0.735;
0.224,0.041,0.735;
0.223,0.042,0.735;
0.223,0.041,0.735;
0.223,0.040,0.736;
0.223,0.040,0.737;
0.223,0.041,0.737;
0.222,0.040,0.737;
0.222,0.040,0.738;
0.222,0.038,0.739;
0.222,0.038,0.739;
0.222,0.038,0.739;
0.222,0.038,0.740;
0.222,0.037,0.740;
0.222,0.037,0.741;
0.222,0.036,0.742;
0.222,0.036,0.742;
0.222,0.036,0.742;
0.222,0.035,0.743;
0.222,0.035,0.744;
0.222,0.035,0.744;
0.222,0.035,0.744;
0.222,0.034,0.744;
0.222,0.034,0.744;
0.222,0.033,0.745;
0.222,0.033,0.745;
0.222,0.033,0.745;
0.222,0.031,0.747;
0.221,0.031,0.748;
0.221,0.031,0.748;
0.221,0.030,0.749;
0.221,0.030,0.749;
0.221,0.029,0.749;
0.221,0.029,0.749;
0.221,0.029,0.750;
0.221,0.029,0.750;
0.221,0.029,0.750;
0.221,0.028,0.751;
0.221,0.028,0.751;
0.220,0.028,0.751;
0.220,0.028,0.752;
0.220,0.028,0.752;
0.220,0.028,0.752;
0.220,0.028,0.752;
0.220,0.027,0.753;
0.220,0.027,0.753;
0.219,0.028,0.753;
0.219,0.026,0.755;
0.219,0.026,0.755;
0.219,0.025,0.756;
0.219,0.025,0.756;
0.219,0.025,0.756;
0.219,0.025,0.756;
0.219,0.025,0.756;
0.219,0.024,0.757;
0.219,0.025,0.757;
0.218,0.025,0.757;
0.218,0.025,0.757;
0.218,0.024,0.757;
0.218,0.023,0.759;
0.218,0.023,0.759;
0.218,0.022,0.759;
0.218,0.022,0.759;
0.218,0.022,0.759;
0.218,0.022,0.760;
0.218,0.022,0.760;
0.218,0.022,0.760;
0.218,0.022,0.760;
0.218,0.022,0.761;
0.217,0.022,0.761;
0.217,0.022,0.761;
0.217,0.021,0.762;
0.217,0.021,0.762;
0.217,0.021,0.762;
0.217,0.020,0.762;
0.217,0.020,0.763;
0.217,0.020,0.763;
0.217,0.020,0.763;
0.217,0.020,0.763;
0.217,0.019,0.764;
0.217,0.019,0.764;
0.217,0.019,0.764;
0.217,0.018,0.764;
0.217,0.019,0.764;
0.217,0.018,0.765;
0.217,0.018,0.765;
0.217,0.017,0.766;
0.217,0.017,0.766;
0.217,0.017,0.766;
0.217,0.017,0.766;
0.217,0.017,0.766;
0.217,0.017,0.766;
0.216,0.017,0.766;
0.216,0.017,0.766;
0.216,0.017,0.766;
0.216,0.017,0.766;
0.216,0.017,0.766;
0.216,0.017,0.767;
0.216,0.016,0.768;
0.216,0.016,0.768;
0.216,0.016,0.768;
0.216,0.016,0.768;
0.216,0.017,0.768;
0.216,0.017,0.768;
0.216,0.017,0.768;
0.216,0.017,0.768;
0.216,0.017,0.768;
0.216,0.016,0.769;
0.216,0.016,0.769;
0.216,0.016,0.769;
0.216,0.015,0.769;
0.216,0.015,0.769;
0.216,0.015,0.769;
0.216,0.015,0.770;
0.215,0.015,0.770;
0.215,0.014,0.770;
0.215,0.014,0.771;
0.215,0.013,0.771;
0.215,0.013,0.771;
0.215,0.013,0.772;
0.215,0.013,0.772;
0.215,0.013,0.772;
0.215,0.013,0.772;
0.215,0.012,0.773;
0.215,0.012,0.773;
0.215,0.012,0.773;
0.215,0.012,0.773;
0.215,0.012,0.773;
0.215,0.012,0.774;
0.215,0.011,0.774;
0.215,0.011,0.774;
0.215,0.011,0.774;
0.215,0.011,0.774;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.010,0.775;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.776;
0.215,0.009,0.777;
0.215,0.009,0.777;
0.215,0.009,0.777;
0.215,0.008,0.777;
0.214,0.008,0.777;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.214,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.778;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.008,0.779;
0.213,0.007,0.779;
0.213,0.007,0.780;
0.213,0.007,0.780;
0.213,0.007,0.780;
0.213,0.006,0.780;
0.213,0.006,0.780;
0.213,0.006,0.780;
0.213,0.006,0.780;
0.213,0.006,0.781;
0.213,0.006,0.781;
0.213,0.006,0.781;
0.213,0.006,0.781;
0.213,0.006,0.781;
0.213,0.006,0.781;
0.213,0.007,0.781;
0.213,0.007,0.781;
0.213,0.007,0.781;
0.213,0.006,0.781;
0.212,0.006,0.782;
0.212,0.006,0.782;
0.212,0.007,0.782;
0.212,0.007,0.782;
0.212,0.007,0.782;
0.212,0.007,0.782;
0.212,0.007,0.782;
0.212,0.007,0.782;
0.212,0.006,0.782;
0.212,0.006,0.782;
0.212,0.006,0.782;
0.212,0.006,0.782;
0.212,0.006,0.782;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.783;
0.212,0.005,0.784;
0.212,0.005,0.784;
0.212,0.005,0.784;
0.212,0.005,0.784;
0.212,0.005,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.004,0.784;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.212,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.785;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.003,0.786;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.003,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.787;
0.211,0.002,0.788;
0.211,0.002,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.211,0.001,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.002,0.788;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.001,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
0.210,0.000,0.789;
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
title ('SIRS Dynamics with 0.1 dt, 1500 steps, 0 replications');