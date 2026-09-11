-- SoftberyStore Dashboard - pusat pembersihan data + daftar keuntungan
-- Jalankan SATU KALI di Supabase > SQL Editor.
-- Aman dijalankan ulang: fungsi akan diperbarui dan nilai keuntungan disinkronkan lagi.

create or replace function public.dashboard_purge_data(p_target text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_transactions integer := 0;
  v_customers integer := 0;
  v_logs integer := 0;
begin
  if not exists (
    select 1
    from public.user_roles
    where id = auth.uid() and role = 'OWNER'
  ) then
    raise exception 'Hanya OWNER yang boleh membersihkan database'
      using errcode = '42501';
  end if;

  if p_target not in ('transactions', 'customers', 'sales_data') then
    raise exception 'Target pembersihan tidak valid';
  end if;

  if p_target in ('transactions', 'sales_data') then
    -- Kondisi eksplisit diperlukan pada project yang mengaktifkan
    -- pgsafeupdate. Semua UUID valid pasti bukan null.
    delete from public.transactions as t where t.id is not null;
    get diagnostics v_transactions = row_count;

    -- Trigger audit membuat log DELETE. Bersihkan sesudah transaksi agar tidak
    -- meninggalkan baris audit lama maupun baris audit dari proses ini.
    delete from public.transaction_logs as l where l.id is not null;
    get diagnostics v_logs = row_count;
  end if;

  if p_target in ('customers', 'sales_data') then
    delete from public.customers as c where c.id is not null;
    get diagnostics v_customers = row_count;
  end if;

  return jsonb_build_object(
    'deleted_transactions', v_transactions,
    'deleted_customers', v_customers,
    'deleted_logs', v_logs
  );
end;
$$;

revoke all on function public.dashboard_purge_data(text) from public;
grant execute on function public.dashboard_purge_data(text) to authenticated;

-- Keuntungan katalog SoftberyStore diambil dari profit_config_v2.json milik
-- bot DINDA ketika `npm run migrate` dijalankan. Dengan begitu SQL ini tidak
-- menimpa keuntungan DINDA memakai daftar toko lain.
select name, category, duration, price, cost, profit_amount
from public.products
order by sort_order, category_sort_order, variant_sort_order, name, category, duration;
