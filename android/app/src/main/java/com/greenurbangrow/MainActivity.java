package com.greenurbangrow;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Minimal UI for testing
        TextView tv = new TextView(this);
        tv.setText("Green Urban Grow App");
        setContentView(tv);
    }
}
