package com.example.skeldtcan.myapplication;

import android.content.ContentValues;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    }

    public void onBtn1Clicked(View v) {
        //String url = "http://skeldtcan.iptime.org:8890/?pin=ON";
        String url = "http://192.168.0.33/?pin=ON";

        // AsyncTask를 통해 HttpURLConnection 수행.
        NetworkTask networkTask = new NetworkTask(url, null);
        networkTask.execute();
    }


    public void onBtn2Clicked(View v) {
//        String url = "http://skeldtcan.iptime.org:8889/?pin=ON";
        String url = "http://192.168.0.32/?pin=ON";


        // AsyncTask를 통해 HttpURLConnection 수행.
        NetworkTask networkTask = new NetworkTask(url, null);
        networkTask.execute();
    }


    public void onBtn3Clicked(View v) {
   //     String url = "http://skeldtcan.iptime.org:8888/?pin=ON";
        String url = "http://192.168.0.31/?pin=ON";
        // AsyncTask를 통해 HttpURLConnection 수행.
        NetworkTask networkTask = new NetworkTask(url, null);
        networkTask.execute();
    }




    public class NetworkTask extends AsyncTask<Void, Void, String> {

        private String url;
        private ContentValues values;

        public NetworkTask(String url, ContentValues values) {

            this.url = url;
            this.values = values;
        }

        @Override
        protected String doInBackground(Void... params) {

            String result; // 요청 결과를 저장할 변수.
            RequestHttpURLConnection requestHttpURLConnection = new RequestHttpURLConnection();
            result = requestHttpURLConnection.request(url, values); // 해당 URL로 부터 결과물을 얻어온다.

            return result;
        }


    }
}
