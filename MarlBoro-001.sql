PGDMP  :                     |            M    16.0    16.0 %    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16532    M    DATABASE     w   CREATE DATABASE "M" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE "M";
                postgres    false            �            1259    16613    goal_details    TABLE       CREATE TABLE public.goal_details (
    goal_id integer NOT NULL,
    match_id integer,
    who_score integer,
    who_assist integer,
    CONSTRAINT goal_details_who_assist_check CHECK ((who_assist >= 0)),
    CONSTRAINT goal_details_who_score_check CHECK ((who_score >= 0))
);
     DROP TABLE public.goal_details;
       public         heap    postgres    false            �            1259    16612    goal_details_goal_id_seq    SEQUENCE     �   CREATE SEQUENCE public.goal_details_goal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.goal_details_goal_id_seq;
       public          postgres    false    220            �           0    0    goal_details_goal_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.goal_details_goal_id_seq OWNED BY public.goal_details.goal_id;
          public          postgres    false    219            �            1259    16640    json_mbr    TABLE     A   CREATE TABLE public.json_mbr (
    id integer,
    data jsonb
);
    DROP TABLE public.json_mbr;
       public         heap    postgres    false            �            1259    16602    matches    TABLE     �  CREATE TABLE public.matches (
    match_id integer NOT NULL,
    play_date date,
    opponent character varying(20),
    team_points integer,
    scored integer,
    missed integer,
    tournament_id integer,
    ref character varying(50),
    CONSTRAINT matches_scored_check CHECK ((scored >= 0)),
    CONSTRAINT matches_scored_check1 CHECK ((scored >= 0)),
    CONSTRAINT matches_team_points_check CHECK ((team_points = ANY (ARRAY[0, 1, 3])))
);
    DROP TABLE public.matches;
       public         heap    postgres    false            �            1259    16601    matches_match_id_seq    SEQUENCE     �   CREATE SEQUENCE public.matches_match_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.matches_match_id_seq;
       public          postgres    false    218            �           0    0    matches_match_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.matches_match_id_seq OWNED BY public.matches.match_id;
          public          postgres    false    217            �            1259    16635    matches_players    TABLE     g   CREATE TABLE public.matches_players (
    player_id integer NOT NULL,
    match_id integer NOT NULL
);
 #   DROP TABLE public.matches_players;
       public         heap    postgres    false            �            1259    16595    players    TABLE     �   CREATE TABLE public.players (
    player_id integer NOT NULL,
    first_name character varying(15),
    last_name character varying(20),
    birthday date
);
    DROP TABLE public.players;
       public         heap    postgres    false            �            1259    16594    players_player_id_seq    SEQUENCE     �   CREATE SEQUENCE public.players_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.players_player_id_seq;
       public          postgres    false    216            �           0    0    players_player_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.players_player_id_seq OWNED BY public.players.player_id;
          public          postgres    false    215            �            1259    16622    tournaments    TABLE     x  CREATE TABLE public.tournaments (
    tournament_id integer NOT NULL,
    tournament_name character varying(20),
    start_date date,
    end_date date,
    number_of_teams integer,
    our_table_place integer,
    CONSTRAINT tournaments_number_of_teams_check CHECK ((number_of_teams >= 0)),
    CONSTRAINT tournaments_number_of_teams_check1 CHECK ((number_of_teams >= 0))
);
    DROP TABLE public.tournaments;
       public         heap    postgres    false            �            1259    16621    tournaments_tournament_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tournaments_tournament_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.tournaments_tournament_id_seq;
       public          postgres    false    222            �           0    0    tournaments_tournament_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.tournaments_tournament_id_seq OWNED BY public.tournaments.tournament_id;
          public          postgres    false    221            3           2604    16616    goal_details goal_id    DEFAULT     |   ALTER TABLE ONLY public.goal_details ALTER COLUMN goal_id SET DEFAULT nextval('public.goal_details_goal_id_seq'::regclass);
 C   ALTER TABLE public.goal_details ALTER COLUMN goal_id DROP DEFAULT;
       public          postgres    false    219    220    220            2           2604    16605    matches match_id    DEFAULT     t   ALTER TABLE ONLY public.matches ALTER COLUMN match_id SET DEFAULT nextval('public.matches_match_id_seq'::regclass);
 ?   ALTER TABLE public.matches ALTER COLUMN match_id DROP DEFAULT;
       public          postgres    false    218    217    218            1           2604    16598    players player_id    DEFAULT     v   ALTER TABLE ONLY public.players ALTER COLUMN player_id SET DEFAULT nextval('public.players_player_id_seq'::regclass);
 @   ALTER TABLE public.players ALTER COLUMN player_id DROP DEFAULT;
       public          postgres    false    216    215    216            4           2604    16625    tournaments tournament_id    DEFAULT     �   ALTER TABLE ONLY public.tournaments ALTER COLUMN tournament_id SET DEFAULT nextval('public.tournaments_tournament_id_seq'::regclass);
 H   ALTER TABLE public.tournaments ALTER COLUMN tournament_id DROP DEFAULT;
       public          postgres    false    221    222    222            �          0    16613    goal_details 
   TABLE DATA           P   COPY public.goal_details (goal_id, match_id, who_score, who_assist) FROM stdin;
    public          postgres    false    220   �*       �          0    16640    json_mbr 
   TABLE DATA           ,   COPY public.json_mbr (id, data) FROM stdin;
    public          postgres    false    224   �*       �          0    16602    matches 
   TABLE DATA           q   COPY public.matches (match_id, play_date, opponent, team_points, scored, missed, tournament_id, ref) FROM stdin;
    public          postgres    false    218   �+       �          0    16635    matches_players 
   TABLE DATA           >   COPY public.matches_players (player_id, match_id) FROM stdin;
    public          postgres    false    223   K,       �          0    16595    players 
   TABLE DATA           M   COPY public.players (player_id, first_name, last_name, birthday) FROM stdin;
    public          postgres    false    216   �,       �          0    16622    tournaments 
   TABLE DATA           }   COPY public.tournaments (tournament_id, tournament_name, start_date, end_date, number_of_teams, our_table_place) FROM stdin;
    public          postgres    false    222   �-       �           0    0    goal_details_goal_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.goal_details_goal_id_seq', 12, true);
          public          postgres    false    219            �           0    0    matches_match_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.matches_match_id_seq', 5, true);
          public          postgres    false    217            �           0    0    players_player_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.players_player_id_seq', 14, true);
          public          postgres    false    215            �           0    0    tournaments_tournament_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tournaments_tournament_id_seq', 1, true);
          public          postgres    false    221            A           2606    16620    goal_details goal_details_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.goal_details
    ADD CONSTRAINT goal_details_pkey PRIMARY KEY (goal_id);
 H   ALTER TABLE ONLY public.goal_details DROP CONSTRAINT goal_details_pkey;
       public            postgres    false    220            ?           2606    16610    matches matches_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);
 >   ALTER TABLE ONLY public.matches DROP CONSTRAINT matches_pkey;
       public            postgres    false    218            E           2606    16639 $   matches_players matches_players_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.matches_players
    ADD CONSTRAINT matches_players_pkey PRIMARY KEY (player_id, match_id);
 N   ALTER TABLE ONLY public.matches_players DROP CONSTRAINT matches_players_pkey;
       public            postgres    false    223    223            =           2606    16600    players players_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (player_id);
 >   ALTER TABLE ONLY public.players DROP CONSTRAINT players_pkey;
       public            postgres    false    216            C           2606    16629    tournaments tournaments_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.tournaments
    ADD CONSTRAINT tournaments_pkey PRIMARY KEY (tournament_id);
 F   ALTER TABLE ONLY public.tournaments DROP CONSTRAINT tournaments_pkey;
       public            postgres    false    222            �   K   x�5���0B�a/�M����=�pBA�ÐPp�\�m6�≁��/�����\�g�j��}�| �      �   �   x�����0���)H����'��7���F-�����wW�`�P��|ә�ŃWh��&�"�ˀM�[�v�s
z�1N���^-�D]��O&	���Kc�`�7:�}<&�z��R�r-���X�"�=+������-ܡ>OTX��rBG��"�V�6tB��\j��kAW(���S��j��Qģ���+���C      �   o   x���M
�0E��}{I�w_��MtЩ A,�6���@���~�S���Z�g����\޿���q�R�#�B��O�%��:����nc�r/��Մ�u�`Ǜ4�q�/7�,�      �   E   x�˹� ���+������@�ț%��v�i����k�:���~�sĈ#F�1b�)��b��o�����      �     x�M��n�@����l�����"�
!*TNE�X5+6I�I��k���ŗ�3�1�Ǧ|����@�jE��E���;�a]5U�wY�>�&�,0�w�,���2�e,��)�ؖ���R����I�(�PT`+�}�Ms*]��D�Sesx��X��g�=�X���_.����U��t�06	.`�W`���];��-��_�^9r=[�1T��a�����	��:E��z�7_�SJ`2��|8�G�S ң,�R56�I&׌2R*,�F�T�)�����"� �o�      �   .   x�3�t�H,�/K�L�4202�5��5��0�t�8-8M�b���� ��     