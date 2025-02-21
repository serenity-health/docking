<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes of DocKing
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    if (config('docking.console-enabled')) {
        return redirect('/console');
    }
    return view('welcome');
});

if (config('docking.console-enabled')) {
    Route::get('/console', function () {
        return view('console');
    });
}

Route::get('/healthz', function () {
    return 'OK';
});
