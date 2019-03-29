clear;
[stage,Fs] = audioread('game_maoudamashii_4_field04.mp3');
BGMdata.stage = audioplayer(stage,Fs);

[title,Fs] = audioread('game_maoudamashii_4_field06.mp3');
BGMdata.title = audioplayer(title,Fs);

[clear,Fs] = audioread('game_maoudamashii_9_jingle09.mp3');
BGMdata.clear = audioplayer(clear,Fs);

[gameover,Fs] = audioread('game_maoudamashii_7_event38_2.mp3');
BGMdata.gameover = audioplayer(gameover,Fs);

[death,Fs] = audioread('death.mp3');
BGMdata.death = audioplayer(death(ceil(end/23):ceil(end/2)),Fs);

[jump,Fs] = audioread('jump.mp3');
BGMdata.jump.music = jump(ceil(end/160*119):end);
BGMdata.jump.fs = Fs;

[beat,Fs] = audioread('beat.mp3');
BGMdata.beat.music = 4*beat;
BGMdata.beat.fs = Fs;

[pause,Fs] = audioread('se_maoudamashii_onepoint23.mp3');
BGMdata.pause.music = pause;
BGMdata.pause.fs = Fs;
save('BGMdata.mat','BGMdata');