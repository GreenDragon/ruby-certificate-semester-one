FasdUAS 1.101.10   ��   ��    k             l     ��  ��    ' ! Fetch Genre from Top Last.fm Tag     � 	 	 B   F e t c h   G e n r e   f r o m   T o p   L a s t . f m   T a g   
  
 l     ��  ��      �2008 Tom Dale     �      � 2 0 0 8   T o m   D a l e      l     ��  ��    ? 9 Feel free to re-use this code in any manner you see fit,     �   r   F e e l   f r e e   t o   r e - u s e   t h i s   c o d e   i n   a n y   m a n n e r   y o u   s e e   f i t ,      l     ��  ��    ; 5 but please provide credit if releasing your changes.     �   j   b u t   p l e a s e   p r o v i d e   c r e d i t   i f   r e l e a s i n g   y o u r   c h a n g e s .      l     ��  ��      Version 1.0     �      V e r s i o n   1 . 0      l     ��������  ��  ��       !   l    � "���� " O     � # $ # k    � % %  & ' & l   �� ( )��   ( 2 , ensure that something is selected in iTunes    ) � * * X   e n s u r e   t h a t   s o m e t h i n g   i s   s e l e c t e d   i n   i T u n e s '  +�� + Z    � , -���� , >   
 . / . 1    ��
�� 
sele / J    	����   - k    � 0 0  1 2 1 l    3 4 5 3 r     6 7 6 n     8 9 8 1    ��
�� 
pArt 9 1    ��
�� 
sele 7 o      ���� 0 
allartists 
allArtists 4 . ( all artists that are selected in iTunes    5 � : : P   a l l   a r t i s t s   t h a t   a r e   s e l e c t e d   i n   i T u n e s 2  ; < ; l   �� = >��   = R L this includes duplicates if multiple tracks from the same band are selected    > � ? ? �   t h i s   i n c l u d e s   d u p l i c a t e s   i f   m u l t i p l e   t r a c k s   f r o m   t h e   s a m e   b a n d   a r e   s e l e c t e d <  @ A @ l    B C D B r     E F E J    ����   F o      ���� 0 
theartists 
theArtists C 3 - create a hash to hold non-duplicated artists    D � G G Z   c r e a t e   a   h a s h   t o   h o l d   n o n - d u p l i c a t e d   a r t i s t s A  H I H Y    E J�� K L�� J k   * @ M M  N O N r   * 0 P Q P n   * . R S R 4   + .�� T
�� 
cobj T o   , -���� 0 i   S o   * +���� 0 
allartists 
allArtists Q o      ���� 0 n   O  U�� U Z  1 @ V W���� V H   1 5 X X E  1 4 Y Z Y o   1 2���� 0 
theartists 
theArtists Z o   2 3���� 0 n   W r   8 < [ \ [ o   8 9���� 0 n   \ n       ] ^ ]  ;   : ; ^ o   9 :���� 0 
theartists 
theArtists��  ��  ��  �� 0 i   K m    ����  L I   %�� _��
�� .corecnte****       **** _ n   ! ` a ` 2   !��
�� 
cobj a o    ���� 0 
allartists 
allArtists��  ��   I  b c b l  F F��������  ��  ��   c  d�� d X   F � e�� f e k   V � g g  h i h r   V d j k j l  V b l���� l 6  V b m n m 2  V Y��
�� 
cTrk n =  Z a o p o 1   [ ]��
�� 
pArt p o   ^ `���� 0 currentartist currentArtist��  ��   k o      ����  0 trackstomodify tracksToModify i  q r q l  e e�� s t��   s 3 - the following calls the embedded ruby script    t � u u Z   t h e   f o l l o w i n g   c a l l s   t h e   e m b e d d e d   r u b y   s c r i p t r  v w v r   e n x y x n   e l z { z 1   j l��
�� 
psxp { l  e j |���� | I  e j�� }��
�� .earsffdralis        afdr }  f   e f��  ��  ��   y o      ���� 0 mypathu myPathU w  ~  ~ r   o � � � � b   o � � � � b   o ~ � � � b   o z � � � m   o p � � � � � 
 r u b y   � l  p y ����� � n   p y � � � 1   u y��
�� 
strq � l  p u ����� � b   p u � � � o   p q���� 0 mypathu myPathU � m   q t � � � � � R C o n t e n t s / R e s o u r c e s / S c r i p t s / f e t c h _ g e n r e . r b��  ��  ��  ��   � m   z } � � � � �    � l  ~ � ����� � n   ~ � � � � 1    ���
�� 
strq � o   ~ ���� 0 currentartist currentArtist��  ��   � o      ���� 0 mypath myPath   � � � r   � � � � � l  � � ����� � I  � ��� ���
�� .sysoexecTEXT���     TEXT � o   � ����� 0 mypath myPath��  ��  ��   � o      ���� 0 newgenre newGenre �  � � � r   � � � � � I  � ��� � �
�� .sysodlogaskr        TEXT � b   � � � � � b   � � � � � b   � � � � � b   � � � � � m   � � � � � � � N D o   y o u   w a n t   t o   c h a n g e   t h e   g e n r e   o f   a l l   � o   � ����� 0 currentartist currentArtist � m   � � � � � � �    t r a c k s   t o   � o   � ����� 0 newgenre newGenre � l 	 � � ����� � m   � � � � � � �  ?��  ��   � �� � �
�� 
btns � J   � � � �  � � � m   � � � � � � �  D o n ' t   C h a n g e �  ��� � m   � � � � � � �  C h a n g e��   � �� ���
�� 
dflt � m   � ����� ��   � o      ���� 0 response   �  ��� � Z   � � � ����� � =  � � � � � n   � � � � � 1   � ���
�� 
bhit � o   � ����� 0 response   � m   � � � � � � �  C h a n g e � X   � � ��� � � r   � � � � � o   � ����� 0 newgenre newGenre � n       � � � 1   � ���
�� 
pGen � o   � ����� 0 t  �� 0 t   � o   � �����  0 trackstomodify tracksToModify��  ��  ��  �� 0 currentartist currentArtist f o   I J���� 0 
theartists 
theArtists��  ��  ��  ��   $ m      � ��                                                                                  hook   alis    L  Macintosh HD               �1Z�H+     �
iTunes.app                                                      U3��        ����  	                Applications    �1�K      �i1       �  $Macintosh HD:Applications:iTunes.app   
 i T u n e s . a p p    M a c i n t o s h   H D  Applications/iTunes.app   / ��  ��  ��   !  ��� � l     ��������  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �   ����  ��  ��   � �������� 0 i  �� 0 currentartist currentArtist�� 0 t   � # ������������������� ��������� � ��� ������ � � ��~ � ��}�|�{�z�y ��x
�� 
sele
�� 
pArt�� 0 
allartists 
allArtists�� 0 
theartists 
theArtists
�� 
cobj
�� .corecnte****       ****�� 0 n  
�� 
kocl
�� 
cTrk �  ��  0 trackstomodify tracksToModify
�� .earsffdralis        afdr
�� 
psxp�� 0 mypathu myPathU
�� 
strq�� 0 mypath myPath
�� .sysoexecTEXT���     TEXT� 0 newgenre newGenre
�~ 
btns
�} 
dflt�| 
�{ .sysodlogaskr        TEXT�z 0 response  
�y 
bhit
�x 
pGen�� �� �*�,jv �*�,�,E�OjvE�O *k��-j kh  ��/E�O�� 	��6FY h[OY��O ��[��l kh *�-�[�,\Z�81E�O)j �,E�O��a %a ,%a %�a ,%E` O_ j E` Oa �%a %_ %a %a a a lva la  E` O_ a  ,a !  # �[��l kh _ �a ",F[OY��Y h[OY�`Y hU ascr  ��ޭ