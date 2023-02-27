<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FileController extends Controller
{
    public function upload(Request $request)
    {
  if ($request->hasFile('image') && $request->file('image')->isValid()) {
            $file = $request->file('image');
            $fileName = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads'), $fileName);

            return response()->json(['status' => 'success', 'message' => 'File uploaded successfully']);
        }

        return response()->json(['status' => 'error', 'message' => 'File upload failed']);
    }
}
