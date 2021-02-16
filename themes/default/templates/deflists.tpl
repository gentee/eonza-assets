<script>
[[range .DefLists]]
const defLists = {
    [[.Name]]: [
    [[range .Items]]{title: [[.Title]], value: [[.Value]]},
    [[end]]
]
[[end]]
}
</script>