-- 1. Buat user lebih dahulu melalui Supabase > Authentication > Users.
-- 2. Ganti email di bawah dengan email akun tersebut.
-- 3. Jalankan seluruh file ini di Supabase SQL Editor.

do $$
declare
  v_email text := lower('GANTI_DENGAN_EMAIL_OWNER');
  v_user_id uuid;
begin
  select id into v_user_id
  from auth.users
  where lower(email) = v_email
  limit 1;

  if v_user_id is null then
    raise exception 'User % belum ada. Buat dahulu melalui Authentication > Users.', v_email;
  end if;

  insert into public.user_roles(id, email, role)
  values (v_user_id, v_email, 'OWNER')
  on conflict (id) do update
  set email = excluded.email,
      role = 'OWNER',
      updated_at = now();
end
$$;

select email, role from public.user_roles where role = 'OWNER';

